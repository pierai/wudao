import 'package:drift/drift.dart';
import 'habits_table.dart';

/// 习惯执行记录表 - 记录每次习惯的打卡情况
@DataClassName('HabitRecordData')
class HabitRecords extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 关联的习惯 ID（外键，级联删除）
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();

  /// 执行时间（打卡时间）
  DateTimeColumn get executedAt => dateTime()();

  /// 执行质量评分（1-5 星，可选）
  /// 1 星：勉强完成
  /// 3 星：正常完成
  /// 5 星：超预期完成
  IntColumn get quality => integer().nullable()();

  /// 执行笔记（可选）
  /// 用于记录执行过程中的想法、困难、收获等
  TextColumn get notes => text().nullable()();

  /// 是否为补打卡（默认 false）
  /// true：事后补录的打卡记录
  /// false：当时实时打卡
  BoolColumn get isBackfilled => boolean().withDefault(const Constant(false))();

  /// 打卡来源（fromPlan/fromList，默认 fromList）
  TextColumn get source =>
      text().withDefault(const Constant('fromList'))();

  /// 如果来自计划，记录计划 ID
  TextColumn get planId => text().nullable()();

  /// 创建时间（记录创建时间，非执行时间）
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
