import admin from "firebase-admin";

function getFirestoreDb() {
    if (!admin.apps.length) {
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

        // Xử lý các trường hợp format của private key
        privateKey = privateKey.trim();
        if (privateKey.startsWith('"') && privateKey.endsWith('"')) {
            privateKey = privateKey.slice(1, -1);
        }
        privateKey = privateKey.replace(/\\n/g, "\n");

        admin.initializeApp({
            credential: admin.credential.cert({
                projectId: process.env.FIREBASE_PROJECT_ID,
                clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
                privateKey: privateKey,
            }),
        });
    }
    return admin.firestore();
}

export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({
            success: false,
            message: "Method not allowed. Only POST is accepted.",
        });
    }

    try {
        // 1. Khởi tạo kết nối Firestore (Bắt lỗi an toàn nếu thiếu biến môi trường)
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
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`Transaction ${id} saved to Firestore successfully.`);

        // 5. Tìm và cập nhật trạng thái đơn hàng tương ứng trong Firestore
        const rawContent = (content || "").toUpperCase();
        let matchedOrderId = null;

        // Trích xuất mã đơn hàng từ nội dung (VD: SPHHUB12345, SPHHUB_ORD12345, ...)
        const match = rawContent.match(/SPHHUB[_\-\s]?([A-Z0-9]+)/i);
        if (match && match[1]) {
            matchedOrderId = match[1];
        }

        let orderUpdated = false;
        if (matchedOrderId) {
            let orderRef = db.collection("orders").doc(matchedOrderId);
            let orderDoc = await orderRef.get();

            // Nếu không tìm thấy bằng Document ID trực tiếp, thử query theo field `id`
            if (!orderDoc.exists) {
                const querySnap = await db.collection("orders")
                    .where("id", "==", matchedOrderId)
                    .limit(1)
                    .get();
                if (!querySnap.empty) {
                    orderRef = querySnap.docs[0].ref;
                    orderDoc = querySnap.docs[0];
                }
            }

            if (orderDoc.exists) {
                const orderData = orderDoc.data();
                if (Number(transferAmount) >= (orderData.total || 0)) {
                    await orderRef.update({
                        paymentStatus: "paid",
                        status: "confirmed",
                        paymentRef: String(id),
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                        timeline: admin.firestore.FieldValue.arrayUnion({
                            status: "confirmed",
                            note: `Thanh toán SePay thành công (Mã GD: ${id})`,
                            timestamp: new Date(),
                        }),
                    });
                    orderUpdated = true;
                    console.log(`Order ${orderDoc.id} updated to PAID in Firestore!`);
                } else {
                    console.warn(`Amount mismatch for order ${orderDoc.id}: received ${transferAmount}, expected ${orderData.total}`);
                }
            }
        }

        return res.status(200).json({
            success: true,
            message: "Transaction saved",
            orderUpdated,
            orderId: matchedOrderId,
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