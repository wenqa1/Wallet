import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'card_face_table.dart';
import 'card_table.dart';

export 'package:drift/drift.dart' show Value;

part 'app_database.g.dart';

/// 本地数据库：仅存非敏感元数据。
@DriftDatabase(tables: [CardMeta, CardFaceCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'kabao'));

  /// 测试用：注入自定义 QueryExecutor。
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}
