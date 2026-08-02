import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/custom_face.dart';

void main() {
  group('CustomFace JSON', () {
    test('roundtrips gradient + text', () {
      const face = CustomFace(
        colors: [Color(0xFFC8102E), Color(0xFF8C0B20)],
        foreground: Colors.white,
        logoText: 'CMB',
        bankNameText: '招商银行',
      );

      final decoded = CustomFace.fromJson(face.toJson());

      expect(decoded.colors, face.colors);
      expect(decoded.foreground, face.foreground);
      expect(decoded.logoText, 'CMB');
      expect(decoded.bankNameText, '招商银行');
      expect(decoded.imagePath, isNull);
    });

    test('handles imagePath', () {
      final face = CustomFace(
        colors: const [Color(0xFF000000)],
        imagePath: 'custom_faces/1.jpg',
      );

      final decoded = CustomFace.fromJson(face.toJson());

      expect(decoded.imagePath, 'custom_faces/1.jpg');
    });

    test('fromJson tolerates missing fields', () {
      final face = CustomFace.fromJson(const {'colors': []});
      expect(face.colors, isEmpty);
      expect(face.logoText, isNull);
      expect(face.bankNameText, isNull);
      expect(face.foreground, isNull);
    });
  });
}
