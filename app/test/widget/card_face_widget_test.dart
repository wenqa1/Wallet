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
    // 文件创建是真实 I/O，需在 runAsync 中执行。
    late String imagePath;
    await tester.runAsync(() async {
      final dir = await Directory.systemTemp.createTemp('face_test');
      final imageFile = File('${dir.path}/face.jpg');
      await imageFile.writeAsBytes(tinyPng);
      imagePath = imageFile.path;
    });

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
            imagePath: imagePath,
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
