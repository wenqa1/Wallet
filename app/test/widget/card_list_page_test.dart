import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/card_face.dart';
import 'package:kabao/data/repositories/card_face_repository.dart';
import 'package:kabao/features/card_list/card_list_page.dart';

void main() {
  testWidgets('内置卡面清单可加载且包含招行', (tester) async {
    final faces = await const CardFaceRepository().loadBundledFaces();
    expect(faces, isNotEmpty);
    expect(
      faces.any((face) => face.bankCode == 'CMB'),
      isTrue,
      reason: '内置清单应包含招商银行卡面',
    );
  });

  testWidgets('首页渲染示例卡面', (tester) async {
    const fakeFace = CardFace(
      faceId: 'test-cmb',
      bankCode: 'CMB',
      bankName: '招商银行',
      cardTypes: ['debit', 'credit'],
      assetType: 'gradient',
      version: 1,
      colors: [Color(0xFFC8102E), Color(0xFF8C0B20)],
      logoText: 'CMB',
      foreground: Colors.white,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bundledFacesProvider.overrideWith((ref) async => [fakeFace]),
        ],
        child: const MaterialApp(home: CardListPage()),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // 卡面核心内容已渲染。
    expect(find.text('卡包'), findsOneWidget);
    expect(find.text('招商银行'), findsOneWidget);
    expect(find.text('工资卡'), findsOneWidget);
    expect(find.textContaining('••••'), findsOneWidget);

    // 底部统计文本在视口外，滚动后再断言。
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.textContaining('内置卡面库'), findsOneWidget);
  });
}
