import { initializeApp, getApps, cert } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

function getFirestoreDb() {
    if (!getApps().length) {
        let privateKey = process.env.FIREBASE_PRIVATE_KEY;
        if (!privateKey) {
            throw new Error("Missing FIREBASE_PRIVATE_KEY environment variable on Vercel");
        }
        if (!process.env.FIREBASE_PROJECT_ID) {
            throw new Error("Missing FIREBASE_PROJECT_ID environment variable on Vercel");
        }
        if (!process.env.FIREBASE_CLIENT_EMAIL) {
            throw new Error("Missing FIREBASE_CLIENT_EMAIL environment variable on Vercel");
        }

        // Xử lý format của private key
        privateKey = privateKey.trim();
        if (privateKey.startsWith('"') && privateKey.endsWith('"')) {
            privateKey = privateKey.slice(1, -1);
        }
        privateKey = privateKey.replace(/\\n/g, "\n");

        initializeApp({
            credential: cert({
                projectId: process.env.FIREBASE_PROJECT_ID,
                clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
                privateKey: privateKey,
            }),
        });
    }
    return getFirestore();
}

export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({
            success: false,
            message: "Method not allowed. Only POST is accepted.",
        });
    }

    try {
        // 1. Khởi tạo kết nối Firestore
        const db = getFirestoreDb();

        // 2. Kiểm tra API Key của SePay (nếu có cấu hình SEPAY_API_KEY trên Vercel)
        const authHeader = req.headers["authorization"] || req.headers["Authorization"];
        if (process.env.SEPAY_API_KEY) {
            const expectedAuth = `Apikey ${process.env.SEPAY_API_KEY}`;
            if (authHeader !== expectedAuth) {
                console.warn("SePay webhook unauthorized request:", authHeader);
                return res.status(401).json({
                    success: false,
                    message: "Unauthorized request",
                });
            }
        }

        const data = req.body || {};
        console.log("SePay webhook payload received:", JSON.stringify(data));

        const {
            id,
            transferType,
            transferAmount,
            content,
            code,
            transactionDate,
            gateway,
            referenceCode,
        } = data;

        if (!id || transferAmount === undefined || transferAmount === null) {
            return res.status(400).json({
                success: false,
                message: "Invalid transaction payload: missing id or transferAmount",
            });
        }

        // Chỉ xử lý tiền vào (tiền khách chuyển khoản mua hàng)
        if (transferType && transferType !== "in") {
            return res.status(200).json({
                success: true,
                message: "Ignored outgoing transaction (transferType != 'in')",
            });
        }

        const transactionRef = db.collection("transactions").doc(String(id));

        // 3. Chống xử lý trùng giao dịch (Idempotency)
        const transactionDoc = await transactionRef.get();
        if (transactionDoc.exists) {
            console.log(`Transaction ${id} already processed.`);
            return res.status(200).json({
                success: true,
                message: "Transaction already processed",
            });
        }

        // 4. Lưu bản ghi giao dịch vào collection `transactions`
        await transactionRef.set({
            sepayId: String(id),
            amount: Number(transferAmount),
            content: content ?? "",
            code: code ?? null,
            transferType: transferType ?? "in",
            transactionDate: transactionDate ?? null,
            gateway: gateway ?? null,
            referenceCode: referenceCode ?? null,
            createdAt: FieldValue.serverTimestamp(),
        });
        console.log(`Transaction ${id} saved to Firestore successfully.`);

        // 5. Tìm và cập nhật trạng thái đơn hàng tương ứng trong Firestore
        const rawContent = (content || "").toUpperCase().replace(/\s+/g, "");
        let matchedOrderId = null;

        // Trích xuất mã đơn hàng từ nội dung (VD: SPHHUBXI6TANBV2VJI1YC6AYVR -> XI6TANBV2VJI1YC6AYVR)
        const match = rawContent.match(/SPHHUB[_\-\s]?([A-Z0-9]+)/i);
        if (match && match[1]) {
            matchedOrderId = match[1];
        }

        console.log(`Extracted matchedOrderId: "${matchedOrderId}" from content: "${rawContent}"`);

        let targetOrderDoc = null;

        if (matchedOrderId) {
            // 5.1 Thử tìm Document ID chính xác
            const directDoc = await db.collection("orders").doc(matchedOrderId).get();
            if (directDoc.exists) {
                targetOrderDoc = directDoc;
            } else {
                // 5.2 Tìm kiếm không phân biệt hoa thường (Case-Insensitive) trong Firestore
                const ordersSnap = await db.collection("orders").limit(100).get();
                for (const doc of ordersSnap.docs) {
                    const docId = doc.id;
                    const docData = doc.data() || {};
                    const upperDocId = docId.toUpperCase();
                    const upperFieldId = (docData.id || "").toUpperCase();

                    if (
                        upperDocId === matchedOrderId ||
                        upperFieldId === matchedOrderId ||
                        rawContent.includes(upperDocId) ||
                        rawContent.includes(upperFieldId)
                    ) {
                        targetOrderDoc = doc;
                        console.log(`Found order by case-insensitive matching: "${docId}" for search key "${matchedOrderId}"`);
                        break;
                    }
                }
            }
        }

        let orderUpdated = false;
        if (targetOrderDoc && targetOrderDoc.exists) {
            const orderData = targetOrderDoc.data() || {};
            const orderTotal = Number(orderData.total) || 0;
            const receivedAmount = Number(transferAmount) || 0;

            console.log(`Order ${targetOrderDoc.id} found. Total: ${orderTotal}, Received: ${receivedAmount}`);

            if (receivedAmount >= orderTotal) {
                await targetOrderDoc.ref.update({
                    paymentStatus: "paid",
                    status: "confirmed",
                    paymentRef: String(id),
                    updatedAt: FieldValue.serverTimestamp(),
                    timeline: FieldValue.arrayUnion({
                        status: "confirmed",
                        note: `Thanh toán SePay thành công (Mã GD: ${id})`,
                        timestamp: new Date(),
                    }),
                });
                orderUpdated = true;
                console.log(`SUCCESS: Order ${targetOrderDoc.id} updated to PAID in Firestore!`);
            } else {
                console.warn(`Amount mismatch for order ${targetOrderDoc.id}: received ${receivedAmount}, expected ${orderTotal}`);
            }
        } else {
            console.warn(`No matching order found for extracted key "${matchedOrderId}"`);
        }

        return res.status(200).json({
            success: true,
            message: "Transaction saved",
            orderUpdated,
            orderId: targetOrderDoc ? targetOrderDoc.id : matchedOrderId,
        });

    } catch (error) {
        console.error("Webhook processing error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message || String(error),
        });
    }
}