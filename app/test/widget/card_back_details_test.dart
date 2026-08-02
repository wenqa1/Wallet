import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_secret.dart';
import 'package:kabao/shared/widgets/card_back_details.dart';

import '../helpers/fakes.dart';

void main() {
  CardMetaData card({String id = 'c1', String? last4 = '1111'}) {
    return CardMetaData(
      id: id,
      bankCode: 'CMB',
      bankName: '招商银行',
      cardType: 'debit',
      currency: '¥',
      orderIndex: 0,
      last4: last4,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  testWidgets('默认显示遮挡卡号', (tester) async {
    final harness = TestHarness();
    harness.repo.seed(
      CardMetaCompanion.insert(
        id: 'c1',
        bankCode: 'CMB',
        bankName: '招商银行',
        cardType: 'debit',
        last4: const Value('1111'),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
      secret: const CardSecret(cardNumber: '4111111111111111'),
    );

    await tester.pumpWidget(
      harness.scope(
        child: MaterialApp(
          home: Scaffold(body: CardBackDetails(card: card())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('•••• 1111'), findsOneWidget);
    expect(find.text('4111 1111 1111 1111'), findsNothing);
    await harness.close();
  });

  testWidgets('长按卡号显示明文并到时自动隐藏', (tester) async {
    final harness = TestHarness();
    harness.settings.seconds = 5;
    harness.repo.seed(
      CardMetaCompanion.insert(
        id: 'c1',
        bankCode: 'CMB',
        bankName: '招商银行',
        cardType: 'debit',
        last4: const Value('1111'),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
      secret: const CardSecret(
        cardNumber: '4111111111111111',
        holderName: 'ZHANG SAN',
      ),
    );

    await tester.pumpWidget(
      harness.scope(
        child: MaterialApp(
          home: Scaffold(body: CardBackDetails(card: card())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('•••• 1111'));
    await tester.pump();

    expect(find.text('4111 1111 1111 1111'), findsOneWidget);

    // 到时自动隐藏。
    await tester.pump(const Duration(seconds: 6));
    expect(find.text('•••• 1111'), findsOneWidget);
    expect(find.text('4111 1111 1111 1111'), findsNothing);
    await harness.close();
  });
}
