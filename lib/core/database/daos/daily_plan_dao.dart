import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_plans_table.dart';

part 'daily_plan_dao.g.dart';

/// 次日计划数据访问对象
///
/// 提供次日计划的 CRUD 操作和查询方法
@DriftAccessor(tables: [DailyPlans])
class DailyPlanDao extends DatabaseAccessor<AppDatabase>
    with _$DailyPlanDaoMixin {
  DailyPlanDao(AppDatabase db) : super(db);

  /// 监听指定日期的所有计划（按优先级排序）
  Stream<List<DailyPlanData>> watchPlansByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyPlans)
          ..where((tbl) =>
              tbl.planDate.isBiggerOrEqualValue(startOfDay) &
              tbl.planDate.isSmallerThanValue(endOfDay))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  /// 获取指定日期的所有计划
  Future<List<DailyPlanData>> getPlansByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(dailyPlans)
          ..where((tbl) =>
              tbl.planDate.isBiggerOrEqualValue(startOfDay) &
              tbl.planDate.isSmallerThanValue(endOfDay))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  /// 监听指定习惯的所有未完成计划
  Stream<List<DailyPlanData>> watchUncompletedPlansByHabit(String habitId) {
    return (select(dailyPlans)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) & tbl.isCompleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.planDate),
            (t) => OrderingTerm.asc(t.priority),
          ]))
        .watch();
  }

  /// 获取指定日期范围的未完成计划数量
  Future<int> countUncompletedPlans(DateTime startDate, DateTime endDate) async {
    final query = selectOnly(dailyPlans)
      ..addColumns([dailyPlans.id.count()])
      ..where(dailyPlans.planDate.isBiggerOrEqualValue(startDate) &
          dailyPlans.planDate.isSmallerThanValue(endDate) &
          dailyPlans.isCompleted.equals(false));

    final result = await query.getSingle();
    return result.read(dailyPlans.id.count()) ?? 0;
  }

  /// 插入单个计划
  Future<int> insertPlan(DailyPlanData plan) {
    return into(dailyPlans).insert(plan);
  }

  /// 批量插入计划
  Future<void> insertPlans(List<DailyPlanData> plans) async {
    await batch((batch) {
      batch.insertAll(dailyPlans, plans);
    });
  }

  /// 更新计划
  Future<bool> updatePlan(DailyPlanData plan) {
    return update(dailyPlans).replace(plan);
  }

  /// 标记计划为已完成
  Future<int> completePlan(String id, String? recordId) {
    return (update(dailyPlans)..where((tbl) => tbl.id.equals(id))).write(
      DailyPlansCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
        recordId: Value(recordId),
      ),
    );
  }

  /// 取消完成状态
  Future<int> uncompletePlan(String id) {
    return (update(dailyPlans)..where((tbl) => tbl.id.equals(id))).write(
      const DailyPlansCompanion(
        isCompleted: Value(false),
        completedAt: Value(null),
        recordId: Value(null),
      ),
    );
  }

  /// 删除计划
  Future<int> deletePlan(String id) {
    return (delete(dailyPlans)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 删除指定日期之前的所有计划（清理旧数据）
  Future<int> deleteOldPlans(DateTime beforeDate) {
    return (delete(dailyPlans)
          ..where((tbl) => tbl.planDate.isSmallerThanValue(beforeDate)))
        .go();
  }

  /// 获取指定习惯的今日计划
  Future<DailyPlanData?> getTodayPlanByHabit(String habitId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return (select(dailyPlans)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) &
              tbl.planDate.isBiggerOrEqualValue(today) &
              tbl.planDate.isSmallerThanValue(tomorrow))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 统计指定日期的计划完成率
  Future<double> getCompletionRate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // 总计划数
    final totalQuery = selectOnly(dailyPlans)
      ..addColumns([dailyPlans.id.count()])
      ..where(dailyPlans.planDate.isBiggerOrEqualValue(startOfDay) &
          dailyPlans.planDate.isSmallerThanValue(endOfDay));

    final totalResult = await totalQuery.getSingle();
    final total = totalResult.read(dailyPlans.id.count()) ?? 0;

    if (total == 0) return 0.0;

    // 已完成计划数
    final completedQuery = selectOnly(dailyPlans)
      ..addColumns([dailyPlans.id.count()])
      ..where(dailyPlans.planDate.isBiggerOrEqualValue(startOfDay) &
          dailyPlans.planDate.isSmallerThanValue(endOfDay) &
          dailyPlans.isCompleted.equals(true));

    final completedResult = await completedQuery.getSingle();
    final completed = completedResult.read(dailyPlans.id.count()) ?? 0;

    return completed / total;
  }
}
