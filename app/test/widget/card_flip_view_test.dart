import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/shared/widgets/card_flip_view.dart';

void main() {
  testWidgets('点击卡片前后翻转', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 180,
              child: CardFlipView(
                front: ColoredBox(color: Colors.red, child: Text('front')),
                back: ColoredBox(color: Colors.blue, child: Text('back')),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('front'), findsOneWidget);

    await tester.tap(find.byType(CardFlipView));
    await tester.pumpAndSettle();

    expect(find.text('back'), findsOneWidget);
    expect(find.text('front'), findsNothing);
  });
}
