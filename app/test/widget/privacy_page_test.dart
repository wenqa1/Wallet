import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/features/settings/privacy_page.dart';

void main() {
  testWidgets('隐私说明页展示数据本地存储说明', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyPage()));

    expect(find.text('隐私说明'), findsOneWidget);
    expect(find.text('数据存储'), findsOneWidget);
    expect(find.textContaining('仅保存在本机'), findsOneWidget);
    expect(find.textContaining('不上传任何用户数据'), findsOneWidget);
  });
}
