import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/goals_table.dart';
import 'tables/habits_table.dart';
import 'tables/habit_records_table.dart';
import 'tables/daily_plans_table.dart';
import 'tables/habit_frontmatters_table.dart';
import 'tables/habit_associations_table.dart';
import 'daos/goal_dao.dart';
import 'daos/habit_dao.dart';
import 'daos/habit_record_dao.dart';
import 'daos/daily_plan_dao.dart';
import 'daos/frontmatter_dao.dart';
import 'daos/habit_association_dao.dart';

part 'app_database.g.dart';

/// 悟道应用数据库
///
/// 使用 Drift 实现类型安全的 SQLite 数据库
/// 包含人生目标管理和习惯追踪模块
@DriftDatabase(
  tables: [
    Goals,
    Habits,
    HabitRecords,
    DailyPlans,
    HabitFrontmatters,
    HabitAssociations,
  ],
  daos: [
    GoalDao,
    HabitDao,
    HabitRecordDao,
    DailyPlanDao,
    FrontmatterDao,
    HabitAssociationDao,
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await _migrateToV2(m);
          }
          if (from < 3) {
            await _migrateToV3(m);
          }
          if (from < 4) {
            await _migrateToV4(m);
          }
          if (from < 5) {
            await _migrateToV5(m);
          }
          if (from < 6) {
            await _migrateToV6(m);
          }
        },
      );

  /// 迁移到版本 2: 次日计划状态机重构
  Future<void> _migrateToV2(Migrator m) async {
    // 1. daily_plans 表新增字段
    await m.addColumn(dailyPlans, dailyPlans.status);
    await m.addColumn(dailyPlans, dailyPlans.cueCompletedAt);
    await m.addColumn(dailyPlans, dailyPlans.checkedInAt);
    await m.addColumn(dailyPlans, dailyPlans.updatedAt);

    // 2. habit_records 表新增字段
    await m.addColumn(habitRecords, habitRecords.source);
    await m.addColumn(habitRecords, habitRecords.planId);
    await m.addColumn(habitRecords, habitRecords.updatedAt);

    // 3. 迁移旧数据: is_completed = true → status = 'checkedIn'
    await customUpdate(
      'UPDATE daily_plans SET status = ? WHERE is_completed = 1',
      updates: {dailyPlans},
      variables: [Variable.withString('checkedIn')],
    );

    // 4. 迁移旧数据: completed_at → checked_in_at
    await customUpdate(
      'UPDATE daily_plans SET checked_in_at = completed_at WHERE completed_at IS NOT NULL',
      updates: {dailyPlans},
    );
  }

  /// 迁移到版本 3: 添加通知提醒功能
  Future<void> _migrateToV3(Migrator m) async {
    // daily_plans 表新增提醒字段
    await m.addColumn(dailyPlans, dailyPlans.reminderEnabled);
    await m.addColumn(dailyPlans, dailyPlans.reminderMinutesBefore);
  }

  /// 迁移到版本 4: 添加人生目标管理功能
  Future<void> _migrateToV4(Migrator m) async {
    // 创建 goals 表
    await m.createTable(goals);
  }

  /// 迁移到版本 5: 添加习惯关联表和分类枚举
  Future<void> _migrateToV5(Migrator m) async {
    // 创建 habit_associations 表
    await m.createTable(habitAssociations);
  }

  /// 迁移到版本 6: 重构习惯类型系统，移除 isKeystone 字段
  Future<void> _migrateToV6(Migrator m) async {
    // SQLite 不支持直接删除列，需要重建表
    // 1. 创建临时表（没有 isKeystone 列）
    await customStatement('''
      CREATE TABLE habits_new (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        cue TEXT,
        routine TEXT NOT NULL,
        old_routine TEXT,
        reward TEXT,
        type TEXT NOT NULL,
        category TEXT,
        notes TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        CHECK (type != 'REPLACEMENT' OR old_routine IS NOT NULL)
      );
    ''');

    // 2. 复制数据，同时将 isKeystone = true 的习惯类型改为 CORE
    await customStatement('''
      INSERT INTO habits_new
      SELECT
        id, name, cue, routine, old_routine, reward,
        CASE
          WHEN is_keystone = 1 AND type != 'REPLACEMENT' THEN 'CORE'
          ELSE type
        END as type,
        category, notes, is_active, created_at, updated_at, deleted_at
      FROM habits;
    ''');

    // 3. 删除旧表
    await customStatement('DROP TABLE habits;');

    // 4. 重命名新表
    await customStatement('ALTER TABLE habits_new RENAME TO habits;');
  }

  /// 打开数据库连接
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'wudao.db'));

      return NativeDatabase.createInBackground(file);
    });
  }

}
