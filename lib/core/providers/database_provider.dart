import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

/// 数据库单例 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
