import 'package:flutter_dotenv/flutter_dotenv.dart';

/// SepayService — Dịch vụ tạo thông tin và mã QR thanh toán SePay
class SepayService {
  SepayService._();
  static final SepayService instance = SepayService._();

  /// Ngân hàng thụ hưởng mặc định
  String get bankCode =>
      dotenv.env['SEPAY_BANK_CODE'] ?? 'VCB'; // VCB: Vietcombank

  /// Số tài khoản thụ hưởng
  String get accountNumber =>
      dotenv.env['SEPAY_ACCOUNT_NUMBER'] ?? '0000000001';

  /// Tên chủ tài khoản
  String get accountName =>
      dotenv.env['SEPAY_ACCOUNT_NAME'] ?? 'HO KINH DOANH TEST 3746';

  /// Sinh nội dung chuyển khoản chuẩn hóa cho SePay
  /// Ví dụ: SPHHUB6C838A12
  String buildTransferContent(String orderId) {
    // Rút gọn nếu orderId quá dài để dễ hiển thị trên app ngân hàng
    final cleanId = orderId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    return 'SPHHUB$cleanId';
  }

  /// Sinh đường dẫn ảnh QR Code từ SePay
  String buildQRUrl({
    String? bank,
    String? acc,
    String? name,
    required double amount,
    required String content,
  }) {
    final effectiveBank = bank ?? bankCode;
    final effectiveAcc = acc ?? accountNumber;

    return 'https://qr.sepay.vn/img?acc=$effectiveAcc'
        '&bank=$effectiveBank'
        '&amount=${amount.toInt()}'
        '&des=${Uri.encodeComponent(content)}'
        '&template=compact';
  }
}
