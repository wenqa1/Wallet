import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/card_face.dart';
import 'package:kabao/shared/widgets/card_face_widget.dart';

void main() {
  // 1x1 透明 PNG。
  final tinyPng = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
  );

  testWidgets('远程卡面使用本地图片渲染', (tester) async {
    final dir = await Directory.systemTemp.createTemp('face_test');
    addTearDown(() => dir.delete(recursive: true));
    final imageFile = File('${dir.path}/face.jpg');
    await imageFile.writeAsBytes(tinyPng);

    const face = CardFace(
      faceId: 'remote-1',
      bankCode: 'CMB',
      bankName: '招商银行',
      cardTypes: ['debit'],
      assetType: 'remote',
      imageUrl: 'https://example.com/face.jpg',
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardFaceWidget(
            face: face,
            imagePath: imageFile.path,
            nickname: '工资卡',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('工资卡'), findsOneWidget);
  });
}
