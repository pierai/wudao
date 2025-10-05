import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habit_records_table.dart';

part 'habit_record_dao.g.dart';

/// 习惯执行记录数据访问对象
///
/// 提供打卡记录的 CRUD 操作和查询方法
@DriftAccessor(tables: [HabitRecords])
class HabitRecordDao extends DatabaseAccessor<AppDatabase>
    with _$HabitRecordDaoMixin {
  HabitRecordDao(AppDatabase db) : super(db);

  /// 监听指定习惯的所有记录（按执行时间倒序）
  Stream<List<HabitRecordData>> watchRecordsByHabitId(String habitId) {
    return (select(habitRecords)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .watch();
  }

  /// 获取指定习惯的所有记录（用于统计计算）
  Future<List<HabitRecordData>> getRecordsByHabitId(String habitId) {
    return (select(habitRecords)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .get();
  }

  /// 获取指定日期范围内的记录
  Future<List<HabitRecordData>> getRecordsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(habitRecords)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) &
              tbl.executedAt.isBiggerOrEqualValue(startDate) &
              tbl.executedAt.isSmallerThanValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .get();
  }

  /// 检查指定日期是否已打卡
  Future<bool> hasRecordOnDate(String habitId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = selectOnly(habitRecords)
      ..addColumns([habitRecords.id.count()])
      ..where(habitRecords.habitId.equals(habitId) &
          habitRecords.executedAt.isBiggerOrEqualValue(startOfDay) &
          habitRecords.executedAt.isSmallerThanValue(endOfDay));

    final result = await query.getSingle();
    return (result.read(habitRecords.id.count()) ?? 0) > 0;
  }

  /// 获取指定日期的打卡记录
  Future<HabitRecordData?> getRecordOnDate(
      String habitId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(habitRecords)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) &
              tbl.executedAt.isBiggerOrEqualValue(startOfDay) &
              tbl.executedAt.isSmallerThanValue(endOfDay))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 插入打卡记录
  Future<int> insertRecord(HabitRecordData record) {
    return into(habitRecords).insert(record);
  }

  /// 更新打卡记录
  Future<bool> updateRecord(HabitRecordData record) {
    return update(habitRecords).replace(record);
  }

  /// 删除打卡记录
  Future<int> deleteRecord(String id) {
    return (delete(habitRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 获取所有打卡记录
  Future<List<HabitRecordData>> getAllRecords() {
    return select(habitRecords).get();
  }

  /// 获取指定月份的打卡日历数据
  /// 返回 Map<日期, 记录列表>
  Future<Map<DateTime, List<HabitRecordData>>> getMonthCalendar(
    String habitId,
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    final records = await getRecordsByDateRange(habitId, startDate, endDate);

    final calendar = <DateTime, List<HabitRecordData>>{};
    for (final record in records) {
      final dateKey = DateTime(
        record.executedAt.year,
        record.executedAt.month,
        record.executedAt.day,
      );

      calendar.putIfAbsent(dateKey, () => []).add(record);
    }

    return calendar;
  }

  /// 统计指定习惯的总打卡次数
  Future<int> countTotalRecords(String habitId) async {
    final query = selectOnly(habitRecords)
      ..addColumns([habitRecords.id.count()])
      ..where(habitRecords.habitId.equals(habitId));

    final result = await query.getSingle();
    return result.read(habitRecords.id.count()) ?? 0;
  }

  /// 统计本周打卡次数
  Future<int> countWeekRecords(String habitId) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

    final query = selectOnly(habitRecords)
      ..addColumns([habitRecords.id.count()])
      ..where(habitRecords.habitId.equals(habitId) &
          habitRecords.executedAt.isBiggerOrEqualValue(startOfWeek));

    final result = await query.getSingle();
    return result.read(habitRecords.id.count()) ?? 0;
  }

  /// 获取最新的 N 条记录
  Future<List<HabitRecordData>> getLatestRecords(String habitId, int limit) {
    return (select(habitRecords)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)])
          ..limit(limit))
        .get();
  }

  /// 获取所有补打卡记录
  Future<List<HabitRecordData>> getBackfilledRecords(String habitId) {
    return (select(habitRecords)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) & tbl.isBackfilled.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .get();
  }
}
