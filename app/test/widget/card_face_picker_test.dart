import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/card_face/card_face_picker_sheet.dart';
import 'package:kabao/shared/widgets/card_face_widget.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('卡面选择器浏览并返回所选 faceId', (tester) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showCardFacePicker(context, faces: testFaces);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // 两个卡面平铺渲染。
    expect(find.byType(CardFaceWidget), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('picker_face_cmb-test')));
    await tester.pumpAndSettle();

    expect(result, 'cmb-test');
  });
}
