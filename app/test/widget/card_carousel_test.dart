import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/shared/widgets/card_carousel.dart';

import '../helpers/fakes.dart';

void main() {
  late TestHarness harness;

  setUp(() {
    harness = TestHarness();
  });

  tearDown(() => harness.close());

  CardMetaData meta(String id, String nickname) {
    return CardMetaData(
      id: id,
      bankCode: 'CMB',
      bankName: '招商银行',
      cardType: 'debit',
      currency: '¥',
      orderIndex: 0,
      last4: '1111',
      nickname: nickname,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  testWidgets('轮播展示首张卡并可滑动到第二张', (tester) async {
    final cards = [meta('l1', '卡一'), meta('l2', '卡二')];

    await tester.pumpWidget(
      harness.scope(
        child: MaterialApp(
          home: Scaffold(
            body: CardCarousel(
              cards: cards,
              faces: testFaces,
              banks: testBanks,
              onEdit: (_) {},
              onDelete: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('卡一'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('卡二'), findsOneWidget);
  });
}
