const crypto = require("crypto");

export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({
            success: false,
            message: "Method not allowed",
        });
    }

    try {
        const secret = process.env.SEPAY_WEBHOOK_SECRET;

        if (!secret) {
            console.error("SEPAY_WEBHOOK_SECRET is not configured");

            return res.status(500).json({
                success: false,
                message: "Webhook secret is not configured",
            });
        }

        const signature = req.headers["x-sepay-signature"] || "";
        const timestamp = req.headers["x-sepay-timestamp"] || "";

        if (!signature || !timestamp) {
            return res.status(401).json({
                success: false,
                message: "Missing SePay signature or timestamp",
            });
        }

        // Payload phải là RAW BODY
        const payload =
            typeof req.body === "string"
                ? req.body
                : JSON.stringify(req.body);

        // SePay ký: timestamp.raw_body
        const signedPayload = `${timestamp}.${payload}`;

        const expected =
            "sha256=" +
            crypto
                .createHmac("sha256", secret)
                .update(signedPayload)
                .digest("hex");

        // So sánh an toàn
        const isValid =
            signature.length === expected.length &&
            crypto.timingSafeEqual(
                Buffer.from(signature),
                Buffer.from(expected)
            );

        if (!isValid) {
            console.warn("Invalid SePay webhook signature");

            return res.status(401).json({
                success: false,
                message: "Invalid signature",
            });
        }

        console.log("========== SEPAY WEBHOOK ==========");
        console.log(req.body);

        // =================================
        // ĐẾN ĐÂY WEBHOOK ĐÃ ĐƯỢC XÁC THỰC
        // =================================

        // TODO:
        // 1. Kiểm tra loại giao dịch = tiền vào
        // 2. Kiểm tra số tiền
        // 3. Kiểm tra nội dung chuyển khoản
        // 4. Kiểm tra transaction_id đã xử lý chưa
        // 5. Cập nhật Firestore
        // 6. Đánh dấu đơn hàng = paid

        return res.status(200).json({
            success: true,
            message: "Webhook received",
        });

    } catch (error) {
        console.error("Webhook error:", error);

        return res.status(500).json({
            success: false,
            message: "Internal server error",
        });
    }
}