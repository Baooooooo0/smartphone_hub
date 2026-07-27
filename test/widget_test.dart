import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartphonehub/main.dart';

void main() {
  testWidgets('SmartphoneHubApp renders without crash', (WidgetTester tester) async {
    // Dùng fakeAsync để kiểm soát timer (tránh pending timer error)
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SmartphoneHubApp(),
        ),
      );
      // Chỉ pump 1 frame đầu — không chờ timer của SplashScreen
      await tester.pump();
    });

    // Verify app render được MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
