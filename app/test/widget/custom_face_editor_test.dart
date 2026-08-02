import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/custom_face.dart';
import 'package:kabao/features/card_face/custom_face_editor_page.dart';

void main() {
  testWidgets('自定义卡面编辑器保存带文字的自定义卡面', (tester) async {
    tester.view.physicalSize = const Size(2400, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    CustomFace? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await Navigator.push<CustomFace>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CardCustomFaceEditor(),
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('custom_logo_text')),
      'MYBANK',
    );
    await tester.enterText(
      find.byKey(const Key('custom_bank_name_text')),
      '我的银行',
    );
    await tester.tap(find.byKey(const Key('custom_save_button')));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.logoText, 'MYBANK');
    expect(result!.bankNameText, '我的银行');
    expect(result!.colors, isNotEmpty);
  });
}
