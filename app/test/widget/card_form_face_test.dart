import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/custom_face.dart';
import 'package:kabao/features/add_card/card_form_page.dart';

import '../helpers/fakes.dart';

void main() {
  late TestHarness harness;

  setUp(() {
    harness = TestHarness();
  });

  tearDown(() => harness.close());

  Future<void> pumpForm(WidgetTester tester) async {
    // 表单含卡面区块与保存按钮，用加高视口保证全可见。
    tester.view.physicalSize = const Size(2400, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      harness.scope(child: const MaterialApp(home: CardFormPage())),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> tapSave(WidgetTester tester) async {
    final saveButton = find.byKey(const Key('save_button'));
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> enterValidNumber(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const Key('card_number')),
      '4111111111111111',
    );
  }

  testWidgets('从卡面库选择后保存写入 faceId', (tester) async {
    await pumpForm(tester);
    await enterValidNumber(tester);

    await tester.tap(find.byKey(const Key('pick_face_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('picker_face_cmb-test')));
    await tester.pumpAndSettle();

    await tapSave(tester);

    final cards = await harness.repo.watchAllCards().first;
    expect(cards.length, 1);
    expect(cards.first.faceId, 'cmb-test');
  });

  testWidgets('自定义卡面后保存写入 customFace JSON', (tester) async {
    await pumpForm(tester);
    await enterValidNumber(tester);

    await tester.tap(find.byKey(const Key('custom_face_button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('custom_logo_text')), 'MYBANK');
    await tester.tap(find.byKey(const Key('custom_save_button')));
    await tester.pumpAndSettle();

    await tapSave(tester);

    final cards = await harness.repo.watchAllCards().first;
    expect(cards.length, 1);
    expect(cards.first.customFace, isNotNull);
    final custom = CustomFace.fromJson(
      jsonDecode(cards.first.customFace!) as Map<String, dynamic>,
    );
    expect(custom.logoText, 'MYBANK');
  });
}
