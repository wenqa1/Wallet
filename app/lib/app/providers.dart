import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/bank_catalog.dart';
import '../core/security/secure_storage_service.dart';
import '../data/local/app_database.dart';
import '../data/local/drift_card_face_store.dart';
import '../data/local/settings_store.dart';
import '../data/models/card_face.dart';
import '../data/models/card_secret.dart';
import '../data/network/card_face_remote_api.dart';
import '../data/repositories/card_face_repository.dart';
import '../data/repositories/card_face_store.dart';
import '../data/repositories/card_face_update_service.dart';
import '../data/repositories/card_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final secretStoreProvider = Provider<SecretStore>((ref) {
  return SecureStorageService();
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return DriftCardRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(secretStoreProvider),
  );
});

/// 某张卡的敏感字段（从 Keychain 读取）。
final cardSecretProvider = FutureProvider.family<CardSecret?, String>(
  (ref, cardId) => ref.watch(cardRepositoryProvider).readSecret(cardId),
);

final cardFaceRepositoryProvider = Provider<CardFaceRepository>(
  (ref) => const CardFaceRepository(),
);

final bankCatalogProvider = FutureProvider<List<Bank>>((ref) {
  return const BankCatalog().load();
});

/// 内置卡面库（随包清单）。
final bundledFacesProvider = FutureProvider<List<CardFace>>((ref) {
  return ref.watch(cardFaceRepositoryProvider).loadBundledFaces();
});

/// 卡面资源站地址（M5 搭建后配置），可用 `--dart-define=CARD_FACE_MANIFEST_URL=...` 覆盖。
const cardFaceManifestUrl = String.fromEnvironment(
  'CARD_FACE_MANIFEST_URL',
  defaultValue: 'https://example.com/card_faces/manifest.json',
);

final cardFaceStoreProvider = Provider<CardFaceStore>((ref) {
  return DriftCardFaceStore(ref.watch(appDatabaseProvider));
});

final cardFaceUpdateServiceProvider = Provider<CardFaceUpdateService>((ref) {
  return NetworkCardFaceUpdateService(
    api: DioCardFaceRemoteApi(manifestUrl: cardFaceManifestUrl),
    store: ref.watch(cardFaceStoreProvider),
  );
});

final settingsStoreProvider = Provider<SettingsStore>((ref) {
  return SharedPreferencesSettingsStore();
});

/// 卡号遮挡自动隐藏时长（秒），默认 5。
final maskAutoHideProvider = FutureProvider<int>((ref) {
  return ref.watch(settingsStoreProvider).maskAutoHideSeconds();
});

/// 已下载的远程卡面。
final cachedFacesProvider = FutureProvider<List<CardFace>>((ref) {
  return ref.watch(cardFaceStoreProvider).cachedFaces();
});

/// 生效卡面列表 = 内置 + 远程缓存。
final allFacesProvider = FutureProvider<List<CardFace>>((ref) async {
  final bundled = await ref.watch(bundledFacesProvider.future);
  final cached = await ref.watch(cachedFacesProvider.future);
  return [...bundled, ...cached];
});
