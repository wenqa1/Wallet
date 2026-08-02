import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/network/card_face_remote_api.dart';

void main() {
  test('生成的资源站 manifest 可被 App 解析', () {
    final file = File('../site/manifest.json');
    expect(
      file.existsSync(),
      isTrue,
      reason: '先运行 tools/generate_card_faces.py',
    );

    final manifest = RemoteFaceManifest.fromJson(
      jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
    );

    expect(manifest.manifestVersion, greaterThan(0));
    expect(manifest.faces, isNotEmpty);
    expect(manifest.faces.first.assetType, 'remote');
    expect(manifest.baseUrl, isNotEmpty);
  });
}
