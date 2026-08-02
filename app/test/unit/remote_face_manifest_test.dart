import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/network/card_face_remote_api.dart';

void main() {
  group('RemoteFaceManifest.fromJson', () {
    test('解析清单 JSON', () {
      final manifest = RemoteFaceManifest.fromJson(const {
        'manifestVersion': 8,
        'baseUrl': 'https://x.example/v1/',
        'faces': [
          {
            'faceId': 'cmb-1',
            'bankCode': 'CMB',
            'bankName': '招商银行',
            'cardTypes': ['debit', 'credit'],
            'assetType': 'remote',
            'imageUrl': 'cmb.png',
            'version': 3,
            'fallback': {
              'colors': ['#C8102E', '#8C0B20'],
              'logoText': 'CMB',
            },
          },
        ],
      });

      expect(manifest.manifestVersion, 8);
      expect(manifest.baseUrl, 'https://x.example/v1/');
      expect(manifest.faces, hasLength(1));
      final face = manifest.faces.single;
      expect(face.faceId, 'cmb-1');
      expect(face.assetType, 'remote');
      expect(face.imageUrl, 'cmb.png');
      expect(face.colors.first, const Color(0xFFC8102E));
      expect(face.version, 3);
    });

    test('缺少 faces 时不崩溃', () {
      final manifest = RemoteFaceManifest.fromJson(const {
        'manifestVersion': 1,
      });
      expect(manifest.manifestVersion, 1);
      expect(manifest.faces, isEmpty);
    });
  });
}
