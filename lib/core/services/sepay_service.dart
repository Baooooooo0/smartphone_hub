import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cấu hình thông tin ngân hàng và API SePay
class SepayConfig {
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final String apiToken;
  final String qrTemplate;
  final String contentPrefix;

  const SepayConfig({
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    required this.apiToken,
    this.qrTemplate = 'compact',
    this.contentPrefix = 'SPHHUB',
  });

  factory SepayConfig.fromEnv() {
    return SepayConfig(
      bankCode: dotenv.maybeGet('SEPAY_BANK_CODE') ?? 'MB',
      accountNumber: dotenv.maybeGet('SEPAY_ACCOUNT_NUMBER') ?? '0868888888',
      accountName: dotenv.maybeGet('SEPAY_ACCOUNT_NAME') ?? 'SMARTPHONEHUB',
      apiToken: dotenv.maybeGet('SEPAY_API_TOKEN') ?? '',
      qrTemplate: 'compact',
      contentPrefix: 'SPHHUB',
    );
  }
}

/// Kết quả kiểm tra giao dịch SePay
class SepayTransactionResult {
  final bool isPaid;
  final String? transactionId;
  final double? amountIn;
  final DateTime? transactionDate;
  final String? referenceCode;
  final String? rawContent;
  final String? errorMessage;

  const SepayTransactionResult({
    required this.isPaid,
    this.transactionId,
    this.amountIn,
    this.transactionDate,
    this.referenceCode,
    this.rawContent,
    this.errorMessage,
  });

  factory SepayTransactionResult.unpaid([String? message]) =>
      SepayTransactionResult(isPaid: false, errorMessage: message);

  factory SepayTransactionResult.paid({
    required String transactionId,
    required double amountIn,
    DateTime? transactionDate,
    String? referenceCode,
    String? rawContent,
  }) =>
      SepayTransactionResult(
        isPaid: true,
        transactionId: transactionId,
        amountIn: amountIn,
        transactionDate: transactionDate,
        referenceCode: referenceCode,
        rawContent: rawContent,
      );
}

/// SepayService — Dịch vụ tích hợp thanh toán chuyển khoản SePay (VietQR)
class SepayService {
  final Dio _dio;
  final SepayConfig _config;

  SepayService({
    Dio? dio,
    SepayConfig? config,
  })  : _config = config ?? SepayConfig.fromEnv(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://my.sepay.vn/userapi',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  SepayConfig get config => _config;

  /// Sinh nội dung chuyển khoản chuẩn hóa (VD: SPHHUB8A9B1C2D)
  String generateTransferContent(String orderId) {
    // Lấy tối đa 12 ký tự chữ số/chữ cái viết hoa từ orderId để tránh quá dài
    final cleanId = orderId
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    final shortId = cleanId.length > 10 ? cleanId.substring(cleanId.length - 10) : cleanId;
    return '${_config.contentPrefix}$shortId';
  }

  /// Tạo link ảnh VietQR động từ SePay gateway
  String generateQRUrl({
    required double amount,
    required String orderId,
    String? bankCode,
    String? accountNumber,
    String? accountName,
    String? template,
  }) {
    final effectiveBank = bankCode ?? _config.bankCode;
    final effectiveAcc = accountNumber ?? _config.accountNumber;
    final effectiveTemplate = template ?? _config.qrTemplate;
    final content = generateTransferContent(orderId);

    final encodedContent = Uri.encodeComponent(content);
    return 'https://qr.sepay.vn/img?acc=$effectiveAcc'
        '&bank=$effectiveBank'
        '&amount=${amount.toInt()}'
        '&des=$encodedContent'
        '&template=$effectiveTemplate';
  }

  /// Polling kiểm tra trạng thái giao dịch qua SePay User API (fallback)
  Future<SepayTransactionResult> checkTransactionStatus({
    required String orderId,
    required double expectedAmount,
    DateTime? fromDate,
  }) async {
    if (_config.apiToken.isEmpty) {
      // Nếu chưa cấu hình SePay API Token, trả về unpaid mà không ném lỗi
      return SepayTransactionResult.unpaid('Chưa cấu hình SEPAY_API_TOKEN');
    }

    try {
      final transferContent = generateTransferContent(orderId).toLowerCase();
      final rawOrderId = orderId.toLowerCase();

      final response = await _dio.get(
        '/transactions/list',
        queryParameters: {
          'limit': 20,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_config.apiToken}',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final status = data['status'];
        if (status == 200 || status == true || data['messages']?['success'] == true) {
          final transactions = data['transactions'] as List<dynamic>? ?? [];

          for (final item in transactions) {
            if (item is! Map<String, dynamic>) continue;

            final transactionContent =
                (item['transaction_content'] ?? item['description'] ?? '')
                    .toString()
                    .toLowerCase();
            final amountIn =
                double.tryParse(item['amount_in']?.toString() ?? '0') ?? 0.0;

            // Kiểm tra nội dung chuyển khoản chứa mã giao dịch và số tiền hợp lệ
            final matchesContent = transactionContent.contains(transferContent) ||
                transactionContent.contains(rawOrderId);

            if (matchesContent && amountIn >= expectedAmount) {
              DateTime? txDate;
              if (item['transaction_date'] != null) {
                txDate = DateTime.tryParse(item['transaction_date'].toString());
              }

              return SepayTransactionResult.paid(
                transactionId: (item['id'] ?? item['transaction_id'] ?? '').toString(),
                amountIn: amountIn,
                transactionDate: txDate,
                referenceCode: item['reference_number']?.toString(),
                rawContent: item['transaction_content']?.toString(),
              );
            }
          }
        }
      }

      return SepayTransactionResult.unpaid();
    } on DioException catch (e) {
      return SepayTransactionResult.unpaid(
        'Lỗi kết nối kiểm tra thanh toán: ${e.message}',
      );
    } catch (e) {
      return SepayTransactionResult.unpaid('Lỗi kiểm tra giao dịch: $e');
    }
  }
}

/// Provider cho SepayService
final sepayServiceProvider = Provider<SepayService>((ref) {
  return SepayService();
});
