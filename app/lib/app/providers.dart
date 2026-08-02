import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/security/secure_storage_service.dart';
import '../data/local/app_database.dart';
import '../data/repositories/card_face_repository.dart';
import '../data/repositories/card_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => CardRepository(ref.watch(appDatabaseProvider)),
);

final cardFaceRepositoryProvider = Provider<CardFaceRepository>(
  (ref) => const CardFaceRepository(),
);
