import 'package:flutter_test/flutter_test.dart';
import 'package:smartphonehub/core/services/sepay_service.dart';

void main() {
  group('SepayService Tests', () {
    const config = SepayConfig(
      bankCode: 'MB',
      accountNumber: '0868888888',
      accountName: 'SMARTPHONEHUB',
      apiToken: 'test_token',
      qrTemplate: 'compact',
      contentPrefix: 'SPHHUB',
    );

    late SepayService service;

    setUp(() {
      service = SepayService(config: config);
    });

    test('generateTransferContent formats content properly', () {
      final content = service.generateTransferContent('order_12345_abc');
      expect(content, 'SPHHUBER12345ABC');
      expect(content.startsWith('SPHHUB'), isTrue);
    });

    test('generateQRUrl generates valid VietQR url with parameters', () {
      final qrUrl = service.generateQRUrl(
        amount: 25000000,
        orderId: 'ORD999',
      );

      expect(qrUrl, contains('https://qr.sepay.vn/img?'));
      expect(qrUrl, contains('acc=0868888888'));
      expect(qrUrl, contains('bank=MB'));
      expect(qrUrl, contains('amount=25000000'));
      expect(qrUrl, contains('des=SPHHUBORD999'));
      expect(qrUrl, contains('template=compact'));
    });

    test('generateQRUrl allows overriding bank and template', () {
      final qrUrl = service.generateQRUrl(
        amount: 1500000,
        orderId: 'ORD123',
        bankCode: 'VCB',
        accountNumber: '99998888',
        template: 'qr_only',
      );

      expect(qrUrl, contains('acc=99998888'));
      expect(qrUrl, contains('bank=VCB'));
      expect(qrUrl, contains('amount=1500000'));
      expect(qrUrl, contains('template=qr_only'));
    });
  });
}
