export default async function handler(req, res) {
    if (req.method !== "POST") {
        return res.status(405).json({
            success: false,
            message: "Method not allowed",
        });
    }

    console.log("========== SEPAY WEBHOOK ==========");
    console.log(req.body);

    return res.status(200).json({
        success: true,
        message: "Webhook received",
    });
}