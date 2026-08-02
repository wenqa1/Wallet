import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/scan/card_scan_parser.dart';
import 'package:kabao/features/scan/scan_result_card.dart';

void main() {
  testWidgets('结果卡展示卡号/姓名/有效期并触发确认与重扫', (tester) async {
    var confirmed = false;
    var rescanned = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScanResultCard(
            candidate: const CardScanCandidate(
              cardNumber: '4111111111111111',
              holderName: 'ZHANG SAN',
              expiry: '08/29',
            ),
            onConfirm: () => confirmed = true,
            onRescan: () => rescanned = true,
          ),
        ),
      ),
    );

    expect(find.text('4111 1111 1111 1111'), findsOneWidget);
    expect(find.text('ZHANG SAN'), findsOneWidget);
    expect(find.text('08/29'), findsOneWidget);

    await tester.tap(find.text('确认使用'));
    expect(confirmed, isTrue);

    await tester.tap(find.text('重新扫描'));
    expect(rescanned, isTrue);
  });

  testWidgets('无姓名/有效期时隐藏对应行', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScanResultCard(
            candidate: CardScanCandidate(cardNumber: '4111111111111111'),
            onConfirm: _noop,
            onRescan: _noop,
          ),
        ),
      ),
    );

    expect(find.text('4111 1111 1111 1111'), findsOneWidget);
    expect(find.textContaining('持卡人'), findsNothing);
    expect(find.textContaining('有效期'), findsNothing);
  });
}

void _noop() {}
