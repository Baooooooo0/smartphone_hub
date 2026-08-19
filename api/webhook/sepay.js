import admin from "firebase-admin";

if (!admin.apps.length) {
    const privateKey = process.env.FIREBASE_PRIVATE_KEY
        ? process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n").replace(/^"|"$/g, "")
        : undefined;

    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: process.env.FIREBASE_PROJECT_ID,
            clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
            privateKey: privateKey,
        }),
    });
}

const db = admin.firestore();

export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({
            success: false,
            message: "Method not allowed",
        });
    }

    try {
        // Kiểm tra API Key của SePay (nếu có cấu hình SEPAY_API_KEY trên Vercel)
        const authHeader = req.headers["authorization"] || req.headers["Authorization"];
        if (process.env.SEPAY_API_KEY) {
            const expectedAuth = `Apikey ${process.env.SEPAY_API_KEY}`;
            if (authHeader !== expectedAuth) {
                console.warn("SePay webhook unauthorized request:", authHeader);
                return res.status(401).json({
                    success: false,
                    message: "Unauthorized",
                });
            }
        }

        const data = req.body || {};
        console.log("SePay webhook payload:", data);

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

        if (!id || !transferAmount) {
            return res.status(400).json({
                success: false,
                message: "Invalid transaction",
            });
        }

        // Chỉ xử lý tiền vào (tiền khách chuyển khoản mua hàng)
        if (transferType !== "in") {
            return res.status(200).json({
                success: true,
                message: "Ignored outgoing transaction",
            });
        }

        const transactionRef = db.collection("transactions").doc(String(id));

        // Chống xử lý trùng giao dịch (Idempotency)
        const transactionDoc = await transactionRef.get();
        if (transactionDoc.exists) {
            return res.status(200).json({
                success: true,
                message: "Transaction already processed",
            });
        }

        // 1. Lưu bản ghi giao dịch
        await transactionRef.set({
            sepayId: String(id),
            amount: Number(transferAmount),
            content: content ?? "",
            code: code ?? null,
            transferType,
            transactionDate: transactionDate ?? null,
            gateway: gateway ?? null,
            referenceCode: referenceCode ?? null,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // 2. Tìm và cập nhật trạng thái đơn hàng tương ứng trong Firestore
        // Cú pháp nội dung chuyển khoản thường là: SPHHUB<orderId> hoặc chứa orderId
        const rawContent = (content || "").toUpperCase();
        let matchedOrderId = null;

        // Trích xuất mã đơn hàng từ nội dung (VD: SPHHUB12345, SPHHUB_ORD12345, ...)
        const match = rawContent.match(/SPHHUB[_\-\s]?([A-Z0-9]+)/i);
        if (match && match[1]) {
            matchedOrderId = match[1];
        }

        let orderUpdated = false;
        if (matchedOrderId) {
            // Thử tìm theo document ID trực tiếp
            let orderRef = db.collection("orders").doc(matchedOrderId);
            let orderDoc = await orderRef.get();

            // Nếu không tìm thấy bằng ID trực tiếp, thử query theo field `id`
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
                // Kiểm tra số tiền chuyển khớp hoặc lớn hơn tổng tiền đơn hàng
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
                    console.log(`Order ${orderDoc.id} updated to PAID successfully!`);
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
        console.error("Webhook error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message,
        });
    }
}