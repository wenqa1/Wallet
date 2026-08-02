import '../network/card_face_remote_api.dart';
import 'card_face_store.dart';

/// 一次更新的结果。
class CardFaceUpdateResult {
  const CardFaceUpdateResult({
    this.updated = false,
    this.failure = false,
    this.message,
  });

  final bool updated;
  final bool failure;
  final String? message;
}

/// 卡面增量更新抽象，测试可注入 fake。
abstract interface class CardFaceUpdateService {
  Future<CardFaceUpdateResult> checkForUpdates();
}

/// 卡面增量更新：拉取清单 → 版本比较 → 下载变更图片 → 保存。
///
/// 任何失败都静默回退（返回 failure），不影响内置卡面使用。
class NetworkCardFaceUpdateService implements CardFaceUpdateService {
  NetworkCardFaceUpdateService({required this.api, required this.store});

  final CardFaceRemoteApi api;
  final CardFaceStore store;

  @override
  Future<CardFaceUpdateResult> checkForUpdates() async {
    try {
      final current = await store.currentManifestVersion();
      final remote = await api.fetchManifest();
      if (remote == null || remote.manifestVersion <= current) {
        return const CardFaceUpdateResult();
      }

      var downloaded = 0;
      for (final face in remote.faces) {
        if (face.assetType == 'remote' && face.imageUrl != null) {
          final existing = await store.faceVersion(face.faceId);
          if (existing != face.version) {
            final bytes = await api.downloadImage(
              '${remote.baseUrl}${face.imageUrl}',
            );
            await store.saveImage(face.faceId, bytes);
            downloaded++;
          }
        }
      }

      await store.saveManifest(remote.manifestVersion, remote.faces);
      return CardFaceUpdateResult(
        updated: true,
        message: '已更新 ${remote.faces.length} 张卡面（下载 $downloaded）',
      );
    } catch (_) {
      return const CardFaceUpdateResult(failure: true, message: '更新失败，已回退内置卡面');
    }
  }
}
