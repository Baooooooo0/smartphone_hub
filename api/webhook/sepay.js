import admin from "firebase-admin";

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: process.env.FIREBASE_PROJECT_ID,
            clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
            privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n"),
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
        const data = req.body;

        console.log("SePay webhook:", data);

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

        // Chỉ xử lý tiền vào
        if (transferType !== "in") {
            return res.status(200).json({
                success: true,
                message: "Ignored outgoing transaction",
            });
        }

        // Dùng ID SePay làm document ID
        const transactionRef = db
            .collection("transactions")
            .doc(String(id));

        // Chống xử lý trùng
        const transactionDoc = await transactionRef.get();

        if (transactionDoc.exists) {
            return res.status(200).json({
                success: true,
                message: "Transaction already processed",
            });
        }

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

        return res.status(200).json({
            success: true,
            message: "Transaction saved",
        });

    } catch (error) {
        console.error("Webhook error:", error);

        return res.status(500).json({
            success: false,
            message: "Internal server error",
        });
    }
}