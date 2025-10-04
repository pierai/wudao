import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/habits_table.dart';
import 'tables/habit_records_table.dart';
import 'tables/daily_plans_table.dart';
import 'tables/habit_frontmatters_table.dart';
import 'daos/habit_dao.dart';
import 'daos/habit_record_dao.dart';
import 'daos/daily_plan_dao.dart';
import 'daos/frontmatter_dao.dart';

part 'app_database.g.dart';

/// 悟道应用数据库
///
/// 使用 Drift 实现类型安全的 SQLite 数据库
/// 当前版本包含习惯追踪模块的所有表
@DriftDatabase(
  tables: [
    Habits,
    HabitRecords,
    DailyPlans,
    HabitFrontmatters,
  ],
  daos: [
    HabitDao,
    HabitRecordDao,
    DailyPlanDao,
    FrontmatterDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// 单例模式
  static AppDatabase? _instance;

  /// 获取数据库单例
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 打开数据库连接
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'wudao.db'));

      return NativeDatabase.createInBackground(file);
    });
  }

}
