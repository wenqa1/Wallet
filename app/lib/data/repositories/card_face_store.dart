import 'dart:typed_data';

import '../models/card_face.dart';

/// 卡面缓存存储抽象，测试可注入内存实现。
abstract interface class CardFaceStore {
  /// 当前已缓存的清单版本。
  Future<int> currentManifestVersion();

  /// 某张卡面的版本；未缓存返回 null。
  Future<int?> faceVersion(String faceId);

  /// 保存某张卡面的图片字节。
  Future<void> saveImage(String faceId, Uint8List bytes);

  /// 保存新清单（含全部面），并更新版本。
  Future<void> saveManifest(int version, List<CardFace> faces);

  /// 已缓存的全部远程卡面。
  Future<List<CardFace>> cachedFaces();
}
