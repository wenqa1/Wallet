import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/color_utils.dart';
import '../models/card_face.dart';
import '../repositories/card_face_store.dart';
import 'app_database.dart';

/// Drift 表 + 文件系统实现的卡面缓存。
///
/// 元数据（清单/版本）存 `CardFaceCache` 表，图片存
/// `ApplicationSupport/card_faces/<faceId>.jpg`。
class DriftCardFaceStore implements CardFaceStore {
  DriftCardFaceStore(this._db);

  final AppDatabase _db;

  static String imageFileName(String faceId) => '$faceId.jpg';

  Future<Directory> _facesDir() async {
    final dir = await getApplicationSupportDirectory();
    final facesDir = Directory('${dir.path}/card_faces');
    await facesDir.create(recursive: true);
    return facesDir;
  }

  @override
  Future<int> currentManifestVersion() async {
    final query = _db.selectOnly(_db.cardFaceCache)
      ..addColumns([_db.cardFaceCache.manifestVersion.max()]);
    final row = await query.getSingle();
    return row.read(_db.cardFaceCache.manifestVersion.max()) ?? 0;
  }

  @override
  Future<int?> faceVersion(String faceId) async {
    final query = _db.select(_db.cardFaceCache)
      ..where((t) => t.faceId.equals(faceId));
    final row = await query.getSingleOrNull();
    return row?.version;
  }

  @override
  Future<void> saveImage(String faceId, Uint8List bytes) async {
    final dir = await _facesDir();
    await File('${dir.path}/${imageFileName(faceId)}').writeAsBytes(bytes);
  }

  @override
  Future<String?> imagePath(String faceId) async {
    final dir = await _facesDir();
    final file = File('${dir.path}/${imageFileName(faceId)}');
    return file.existsSync() ? file.path : null;
  }

  @override
  Future<void> saveManifest(int version, List<CardFace> faces) async {
    await _db.transaction(() async {
      await _db.delete(_db.cardFaceCache).go();
      for (final face in faces) {
        await _db.into(_db.cardFaceCache).insert(_companion(face, version));
      }
    });
  }

  CardFaceCacheCompanion _companion(CardFace face, int version) {
    return CardFaceCacheCompanion.insert(
      faceId: face.faceId,
      bankCode: face.bankCode,
      bankName: face.bankName,
      cardTypes: jsonEncode(face.cardTypes),
      assetType: face.assetType,
      imageUrl: face.imageUrl == null
          ? const Value(null)
          : Value(face.imageUrl),
      assetKey: face.assetKey == null
          ? const Value(null)
          : Value(face.assetKey),
      colors: face.colors.isEmpty
          ? const Value(null)
          : Value(jsonEncode([for (final c in face.colors) colorToHex(c)])),
      logoText: face.logoText == null
          ? const Value(null)
          : Value(face.logoText),
      foreground: face.foreground == null
          ? const Value(null)
          : Value(colorToHex(face.foreground!)),
      version: face.version,
      manifestVersion: version,
    );
  }

  @override
  Future<List<CardFace>> cachedFaces() async {
    final rows = await _db.select(_db.cardFaceCache).get();
    return [for (final row in rows) _rowToFace(row)];
  }

  CardFace _rowToFace(CardFaceCacheData row) {
    final colorStrings = row.colors == null
        ? const <dynamic>[]
        : (jsonDecode(row.colors!) as List<dynamic>);
    return CardFace(
      faceId: row.faceId,
      bankCode: row.bankCode,
      bankName: row.bankName,
      cardTypes: (jsonDecode(row.cardTypes) as List<dynamic>).cast<String>(),
      assetType: row.assetType,
      imageUrl: row.imageUrl,
      assetKey: row.assetKey,
      colors: [for (final c in colorStrings) hexToColor(c.toString())],
      logoText: row.logoText,
      foreground: row.foreground != null ? hexToColor(row.foreground!) : null,
      version: row.version,
    );
  }
}
