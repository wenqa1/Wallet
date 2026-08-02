import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/models/card_secret.dart';
import 'package:kabao/features/add_card/card_form_page.dart';

import '../helpers/fakes.dart';

void main() {
  late TestHarness harness;

  setUp(() {
    harness = TestHarness();
  });

  tearDown(() => harness.close());

  Future<void> pumpForm(WidgetTester tester, {String? cardId}) async {
    await tester.pumpWidget(
      harness.scope(
        child: MaterialApp(home: CardFormPage(cardId: cardId)),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('有效卡号保存后写入元数据与 Keychain', (tester) async {
    await pumpForm(tester);

    await tester.enterText(
      find.byKey(const Key('card_number')),
      '6225882000001234',
    );
    await tester.enterText(find.byKey(const Key('nickname')), '工资卡');
    await tester.enterText(find.byKey(const Key('holder_name')), 'ZHANG SAN');
    await tester.enterText(find.byKey(const Key('expiry')), '08/29');
    await tester.enterText(find.byKey(const Key('cvv')), '123');

    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pump();
    await tester.pumpAndSettle();

    final cards = await tester.runAsync(
      () => harness.repo.watchAllCards().first,
    );
    expect(cards, isNotNull);
    expect(cards!.length, 1);
    expect(cards.first.nickname, '工资卡');
    expect(cards.first.last4, '1234');

    final secret = await tester.runAsync(
      () => harness.repo.readSecret(cards.first.id),
    );
    expect(secret!.cardNumber, '6225882000001234');
  });

  testWidgets('无效卡号被拦截并提示，不写入', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.byKey(const Key('card_number')), '1234');
    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pump();

    expect(find.textContaining('卡号'), findsWidgets);
    final cards = await tester.runAsync(
      () => harness.repo.watchAllCards().first,
    );
    expect(cards, isEmpty);
  });

  testWidgets('编辑模式预填并可更新', (tester) async {
    await tester.runAsync(
      () => harness.repo.insertCard(
        CardMetaCompanion.insert(
          id: 'e1',
          bankCode: 'CMB',
          bankName: '招商银行',
          cardType: 'debit',
          last4: const Value('1234'),
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
        secret: const CardSecret(
          cardNumber: '6225882000001234',
          holderName: 'ZHANG SAN',
        ),
      ),
    );

    await pumpForm(tester, cardId: 'e1');

    // 卡号以分组格式预填。
    expect(find.text('6225 8820 0000 1234'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nickname')), '新昵称');
    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pump();
    await tester.pumpAndSettle();

    final meta = await tester.runAsync(() => harness.repo.getCardById('e1'));
    expect(meta!.nickname, '新昵称');
  });
}
