import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/bank_catalog.dart';
import '../core/security/secure_storage_service.dart';
import '../data/local/app_database.dart';
import '../data/repositories/card_face_repository.dart';
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

final cardFaceRepositoryProvider = Provider<CardFaceRepository>(
  (ref) => const CardFaceRepository(),
);

final bankCatalogProvider = FutureProvider<List<Bank>>((ref) {
  return const BankCatalog().load();
});
