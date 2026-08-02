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

  /// 保存按钮在表单底部，先滚动到可见再点。
  Future<void> tapSave(WidgetTester tester) async {
    final saveButton = find.byKey(const Key('save_button'));
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('有效卡号保存后写入元数据与 Keychain', (tester) async {
    await pumpForm(tester);

    await tester.enterText(
      find.byKey(const Key('card_number')),
      '4111111111111111',
    );
    await tester.enterText(find.byKey(const Key('nickname')), '工资卡');
    await tester.enterText(find.byKey(const Key('holder_name')), 'ZHANG SAN');
    await tester.enterText(find.byKey(const Key('expiry')), '08/29');
    await tester.enterText(find.byKey(const Key('cvv')), '123');

    await tapSave(tester);

    final cards = await harness.repo.watchAllCards().first;
    expect(cards.length, 1);
    expect(cards.first.nickname, '工资卡');
    expect(cards.first.last4, '1111');

    final secret = await harness.repo.readSecret(cards.first.id);
    expect(secret!.cardNumber, '4111111111111111');
    expect(secret.expiry, '08/29');
  });

  testWidgets('无效卡号被拦截并提示，不写入', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.byKey(const Key('card_number')), '1234');
    await tapSave(tester);

    expect(find.textContaining('卡号'), findsWidgets);
    final cards = await harness.repo.watchAllCards().first;
    expect(cards, isEmpty);
  });

  testWidgets('编辑模式预填并可更新', (tester) async {
    harness.repo.seed(
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
        cardNumber: '4111111111111111',
        holderName: 'ZHANG SAN',
      ),
    );

    // 编辑模式有卡面预览（高度约 450），加高视口让整表可见。
    tester.view.physicalSize = const Size(2400, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await pumpForm(tester, cardId: 'e1');

    // 卡号以分组格式预填。
    expect(find.text('4111 1111 1111 1111'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nickname')), '新昵称');
    await tapSave(tester);

    final meta = await harness.repo.getCardById('e1');
    expect(meta!.nickname, '新昵称');
  });
}
