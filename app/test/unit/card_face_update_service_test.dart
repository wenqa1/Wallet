import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kabao/data/models/card_face.dart';
import 'package:kabao/data/network/card_face_remote_api.dart';
import 'package:kabao/data/repositories/card_face_store.dart';
import 'package:kabao/data/repositories/card_face_update_service.dart';

/// 内存版远端 API，测试用。
class FakeRemoteApi implements CardFaceRemoteApi {
  RemoteFaceManifest? manifest;
  Object? error;
  final downloads = <String, Uint8List>{};

  @override
  Future<RemoteFaceManifest?> fetchManifest() async {
    if (error != null) throw error!;
    return manifest;
  }

  @override
  Future<Uint8List> downloadImage(String url) async {
    if (error != null) throw error!;
    return downloads[url] ?? Uint8List.fromList(url.codeUnits);
  }
}

/// 内存版卡面存储，测试用。
class FakeFaceStore implements CardFaceStore {
  int currentVersion = 0;
  final faceVersions = <String, int>{};
  final savedImages = <String, Uint8List>{};
  int? savedManifestVersion;
  List<CardFace>? savedFaces;

  @override
  Future<int> currentManifestVersion() async => currentVersion;

  @override
  Future<int?> faceVersion(String faceId) async => faceVersions[faceId];

  @override
  Future<void> saveImage(String faceId, Uint8List bytes) async {
    savedImages[faceId] = bytes;
  }

  @override
  Future<void> saveManifest(int version, List<CardFace> faces) async {
    savedManifestVersion = version;
    savedFaces = faces;
    currentVersion = version;
    for (final face in faces) {
      faceVersions[face.faceId] = face.version;
    }
  }

  @override
  Future<List<CardFace>> cachedFaces() async => savedFaces ?? const [];

  @override
  Future<String?> imagePath(String faceId) async =>
      savedImages.containsKey(faceId) ? '/tmp/$faceId.jpg' : null;
}

CardFace remoteFace(String faceId, {String? imageUrl, int version = 1}) {
  return CardFace(
    faceId: faceId,
    bankCode: 'CMB',
    bankName: '招商银行',
    cardTypes: const ['debit', 'credit'],
    assetType: 'remote',
    imageUrl: imageUrl,
    version: version,
  );
}

void main() {
  late FakeRemoteApi api;
  late FakeFaceStore store;
  late CardFaceUpdateService service;

  setUp(() {
    api = FakeRemoteApi();
    store = FakeFaceStore();
    service = NetworkCardFaceUpdateService(api: api, store: store);
  });

  group('CardFaceUpdateService.checkForUpdates', () {
    test('远端版本不高于本地时不更新', () async {
      store.currentVersion = 5;
      api.manifest = const RemoteFaceManifest(
        manifestVersion: 5,
        baseUrl: 'https://x.example/v1/',
      );

      final result = await service.checkForUpdates();

      expect(result.updated, isFalse);
      expect(result.failure, isFalse);
      expect(store.savedManifestVersion, isNull);
    });

    test('新版本下载远程卡面图片并保存', () async {
      api.manifest = RemoteFaceManifest(
        manifestVersion: 8,
        baseUrl: 'https://x.example/v1/',
        faces: [remoteFace('cmb-1', imageUrl: 'cmb.png', version: 3)],
      );
      api.downloads['https://x.example/v1/cmb.png'] = Uint8List.fromList([
        1,
        2,
        3,
      ]);

      final result = await service.checkForUpdates();

      expect(result.updated, isTrue);
      expect(store.savedImages['cmb-1'], isNotNull);
      expect(store.savedManifestVersion, 8);
      expect(store.savedFaces!.single.faceId, 'cmb-1');
    });

    test('同版本卡面不重复下载', () async {
      store.faceVersions['cmb-1'] = 3;
      api.manifest = RemoteFaceManifest(
        manifestVersion: 8,
        baseUrl: 'https://x.example/v1/',
        faces: [remoteFace('cmb-1', imageUrl: 'cmb.png', version: 3)],
      );

      final result = await service.checkForUpdates();

      expect(result.updated, isTrue); // 清单版本更新但仍保存
      expect(store.savedImages, isEmpty); // 图片版本相同，未重新下载
    });

    test('网络错误回退，不抛异常', () async {
      api.error = Exception('network down');

      final result = await service.checkForUpdates();

      expect(result.failure, isTrue);
      expect(result.updated, isFalse);
    });
  });
}
