import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/local/app_database.dart';
import 'package:kabao/data/repositories/card_face_repository.dart';
import 'package:kabao/features/card_list/card_list_page.dart';

import '../helpers/fakes.dart';

void main() {
  late TestHarness harness;

  setUp(() {
    harness = TestHarness();
  });

  tearDown(() => harness.close());

  CardMetaCompanion metaFor(String id, {String nickname = '工资卡'}) {
    return CardMetaCompanion.insert(
      id: id,
      bankCode: 'CMB',
      bankName: '招商银行',
      cardType: 'debit',
      nickname: Value(nickname),
      last4: const Value('1234'),
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  Future<void> pumpList(WidgetTester tester) async {
    await tester.pumpWidget(
      harness.scope(child: const MaterialApp(home: CardListPage())),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('内置卡面清单可加载且包含招行', (tester) async {
    final faces = await const CardFaceRepository().loadBundledFaces();
    expect(faces, isNotEmpty);
    expect(faces.any((face) => face.bankCode == 'CMB'), isTrue);
  });

  testWidgets('从仓储读取并展示卡片', (tester) async {
    harness.repo.seed(metaFor('l1'));

    await pumpList(tester);

    expect(find.text('工资卡'), findsOneWidget);
    expect(find.textContaining('1234'), findsOneWidget);
  });

  testWidgets('空状态提示', (tester) async {
    await pumpList(tester);

    expect(find.text('还没有卡片'), findsOneWidget);
  });

  testWidgets('删除需二次确认', (tester) async {
    harness.repo.seed(metaFor('l2', nickname: '待删卡'));

    await pumpList(tester);

    // 点击卡片翻转到底部详情，再删除。
    await tester.tap(find.text('待删卡'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认删除'));
    await tester.pump();
    await tester.pumpAndSettle();

    final cards = await harness.repo.watchAllCards().first;
    expect(cards, isEmpty);
  });
}
