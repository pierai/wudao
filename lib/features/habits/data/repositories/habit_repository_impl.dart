import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/habit_dao.dart';
import '../../../../core/database/daos/habit_record_dao.dart';
import '../../../../core/database/daos/daily_plan_dao.dart';
import '../../../../core/database/daos/frontmatter_dao.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../../domain/entities/habit_stats.dart';
import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit_frontmatter.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';
import '../models/habit_record_model.dart';
import '../models/daily_plan_model.dart';
import '../models/habit_frontmatter_model.dart';

/// 习惯仓库实现
///
/// 实现习惯追踪的所有业务逻辑
/// Phase 2: 纯本地 Drift 存储
/// Phase 5+: 可扩展为云端同步（添加 RemoteHabitDataSource）
class HabitRepositoryImpl implements HabitRepository {
  final HabitDao _habitDao;
  final HabitRecordDao _recordDao;
  final DailyPlanDao _planDao;
  final FrontmatterDao _frontmatterDao;

  HabitRepositoryImpl({
    required HabitDao habitDao,
    required HabitRecordDao recordDao,
    required DailyPlanDao planDao,
    required FrontmatterDao frontmatterDao,
  })  : _habitDao = habitDao,
        _recordDao = recordDao,
        _planDao = planDao,
        _frontmatterDao = frontmatterDao;

  // ========== 习惯管理 ==========

  @override
  Future<Habit> createHabit(Habit habit) async {
    await _habitDao.insertHabit(habit.toData());
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _habitDao.updateHabit(habit.toData());
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _habitDao.softDeleteHabit(id);
  }

  @override
  Future<void> hardDeleteHabit(String id) async {
    await _habitDao.hardDeleteHabit(id);
  }

  @override
  Stream<List<Habit>> watchActiveHabits() {
    return _habitDao.watchActiveHabits().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Habit>> watchHabitsByCategory(String category) {
    return _habitDao.watchHabitsByCategory(category).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final data = await _habitDao.getHabitById(id);
    return data?.toEntity();
  }

  @override
  Stream<List<Habit>> searchHabits(String query) {
    return _habitDao.searchHabits(query).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<void> toggleArchive(String id, bool isActive) async {
    await _habitDao.toggleArchive(id, isActive);
  }

  @override
  Future<List<String>> getCategories() {
    return _habitDao.getCategories();
  }

  @override
  Future<int> countActiveHabits() {
    return _habitDao.countActiveHabits();
  }

  // ========== 执行记录管理 ==========

  @override
  Future<void> recordExecution(HabitRecord record) async {
    await _recordDao.insertRecord(record.toData());
  }

  @override
  Future<void> updateRecord(HabitRecord record) async {
    await _recordDao.updateRecord(record.toData());
  }

  @override
  Future<void> deleteRecord(String id) async {
    await _recordDao.deleteRecord(id);
  }

  @override
  Stream<List<HabitRecord>> watchRecordsByHabitId(String habitId) {
    return _recordDao.watchRecordsByHabitId(habitId).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<HabitRecord>> getRecordsByHabitId(String habitId) async {
    final dataList = await _recordDao.getRecordsByHabitId(habitId);
    return dataList.map((data) => data.toEntity()).toList();
  }

  @override
  Future<List<HabitRecord>> getRecordsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final dataList =
        await _recordDao.getRecordsByDateRange(habitId, startDate, endDate);
    return dataList.map((data) => data.toEntity()).toList();
  }

  @override
  Future<bool> hasRecordOnDate(String habitId, DateTime date) {
    return _recordDao.hasRecordOnDate(habitId, date);
  }

  @override
  Future<HabitRecord?> getRecordOnDate(String habitId, DateTime date) async {
    final data = await _recordDao.getRecordOnDate(habitId, date);
    return data?.toEntity();
  }

  @override
  Future<Map<DateTime, List<HabitRecord>>> getMonthCalendar(
    String habitId,
    int year,
    int month,
  ) async {
    final dataCalendar = await _recordDao.getMonthCalendar(habitId, year, month);

    final entityCalendar = <DateTime, List<HabitRecord>>{};
    for (final entry in dataCalendar.entries) {
      entityCalendar[entry.key] =
          entry.value.map((data) => data.toEntity()).toList();
    }

    return entityCalendar;
  }

  // ========== 统计信息 ==========

  @override
  Future<HabitStats> getHabitStats(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);

    if (records.isEmpty) {
      return HabitStats.empty();
    }

    final currentStreak = _calculateCurrentStreak(records);
    final bestStreak = _calculateBestStreak(records);
    final totalExecutions = records.length;
    final thisWeekExecutions = await _recordDao.countWeekRecords(habitId);
    final thisMonthExecutions = _calculateThisMonthExecutions(records);
    final completionRate = _calculateCompletionRate(records);
    final averageQuality = _calculateAverageQuality(records);

    return HabitStats(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalExecutions: totalExecutions,
      thisWeekExecutions: thisWeekExecutions,
      thisMonthExecutions: thisMonthExecutions,
      completionRate: completionRate,
      averageQuality: averageQuality,
      lastExecutedAt: records.first.executedAt,
      firstExecutedAt: records.last.executedAt,
    );
  }

  @override
  Future<int> getCurrentStreak(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);
    return _calculateCurrentStreak(records);
  }

  @override
  Future<int> getBestStreak(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);
    return _calculateBestStreak(records);
  }

  @override
  Future<double> getCompletionRate(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);
    return _calculateCompletionRate(records);
  }

  /// 计算当前连续天数
  ///
  /// 算法：从今天开始向前查找，找到连续打卡的最长天数
  int _calculateCurrentStreak(List<HabitRecordData> records) {
    if (records.isEmpty) return 0;

    // 按执行时间倒序排序
    records.sort((a, b) => b.executedAt.compareTo(a.executedAt));

    int streak = 0;
    final now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    // 检查今天或昨天是否打卡（允许昨天开始连续）
    final latestRecordDate = DateTime(
      records.first.executedAt.year,
      records.first.executedAt.month,
      records.first.executedAt.day,
    );

    final yesterday = currentDate.subtract(const Duration(days: 1));

    if (latestRecordDate != currentDate && latestRecordDate != yesterday) {
      return 0; // 连续已断
    }

    // 从最新记录开始计算连续天数
    currentDate = latestRecordDate;

    for (final record in records) {
      final recordDate = DateTime(
        record.executedAt.year,
        record.executedAt.month,
        record.executedAt.day,
      );

      if (recordDate == currentDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (recordDate.isBefore(currentDate)) {
        // 发现断档，停止计算
        break;
      }
      // 同一天多次打卡，跳过
    }

    return streak;
  }

  /// 计算最佳连续记录
  ///
  /// 算法：遍历所有记录，找到历史上最长的连续天数
  int _calculateBestStreak(List<HabitRecordData> records) {
    if (records.isEmpty) return 0;

    // 按执行时间正序排序
    records.sort((a, b) => a.executedAt.compareTo(b.executedAt));

    int bestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final record in records) {
      final recordDate = DateTime(
        record.executedAt.year,
        record.executedAt.month,
        record.executedAt.day,
      );

      if (lastDate == null) {
        currentStreak = 1;
      } else {
        final diff = recordDate.difference(lastDate).inDays;

        if (diff == 0) {
          // 同一天多次打卡，跳过
          continue;
        } else if (diff == 1) {
          // 连续打卡
          currentStreak++;
        } else {
          // 断档，重新开始
          bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
          currentStreak = 1;
        }
      }

      lastDate = recordDate;
    }

    // 处理最后一段连续
    bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;

    return bestStreak;
  }

  /// 计算本月执行次数
  int _calculateThisMonthExecutions(List<HabitRecordData> records) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    return records
        .where((record) => record.executedAt.isAfter(monthStart))
        .length;
  }

  /// 计算完成率
  ///
  /// 完成率 = 总执行次数 / 从第一次打卡到今天的天数
  double _calculateCompletionRate(List<HabitRecordData> records) {
    if (records.isEmpty) return 0.0;

    final firstRecord = records.reduce(
      (a, b) => a.executedAt.isBefore(b.executedAt) ? a : b,
    );

    final firstDate = DateTime(
      firstRecord.executedAt.year,
      firstRecord.executedAt.month,
      firstRecord.executedAt.day,
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final daysSinceStart = today.difference(firstDate).inDays + 1;

    if (daysSinceStart <= 0) return 0.0;

    return records.length / daysSinceStart;
  }

  /// 计算平均质量评分
  double? _calculateAverageQuality(List<HabitRecordData> records) {
    final recordsWithQuality =
        records.where((r) => r.quality != null).toList();

    if (recordsWithQuality.isEmpty) return null;

    final totalQuality = recordsWithQuality.fold<int>(
      0,
      (sum, record) => sum + record.quality!,
    );

    return totalQuality / recordsWithQuality.length;
  }

  // ========== 次日计划管理 ==========

  @override
  Future<void> createDailyPlan(DailyPlan plan) async {
    await _planDao.insertPlan(plan.toData());
  }

  @override
  Future<void> createDailyPlans(List<DailyPlan> plans) async {
    await _planDao.insertPlans(plans.map((p) => p.toData()).toList());
  }

  @override
  Future<void> updateDailyPlan(DailyPlan plan) async {
    await _planDao.updatePlan(plan.toData());
  }

  @override
  Future<void> completeDailyPlan(String planId, String? recordId) async {
    await _planDao.completePlan(planId, recordId);
  }

  @override
  Future<void> uncompleteDailyPlan(String planId) async {
    await _planDao.uncompletePlan(planId);
  }

  @override
  Future<void> deleteDailyPlan(String planId) async {
    await _planDao.deletePlan(planId);
  }

  @override
  Stream<List<DailyPlan>> watchPlansByDate(DateTime date) {
    return _planDao.watchPlansByDate(date).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<DailyPlan>> getPlansByDate(DateTime date) async {
    final dataList = await _planDao.getPlansByDate(date);
    return dataList.map((data) => data.toEntity()).toList();
  }

  @override
  Stream<List<DailyPlan>> watchUncompletedPlansByHabit(String habitId) {
    return _planDao.watchUncompletedPlansByHabit(habitId).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<DailyPlan?> getTodayPlanByHabit(String habitId) async {
    final data = await _planDao.getTodayPlanByHabit(habitId);
    return data?.toEntity();
  }

  @override
  Future<double> getPlanCompletionRate(DateTime date) {
    return _planDao.getCompletionRate(date);
  }

  @override
  Future<void> deleteOldPlans(DateTime beforeDate) async {
    await _planDao.deleteOldPlans(beforeDate);
  }

  // ========== Frontmatter 管理 ==========

  @override
  Future<void> createFrontmatter(HabitFrontmatter frontmatter) async {
    await _frontmatterDao.insertFrontmatter(frontmatter.toData());
  }

  @override
  Future<void> updateFrontmatter(HabitFrontmatter frontmatter) async {
    await _frontmatterDao.updateFrontmatter(frontmatter.toData());
  }

  @override
  Future<void> deleteFrontmatter(String id) async {
    await _frontmatterDao.deleteFrontmatter(id);
  }

  @override
  Stream<List<HabitFrontmatter>> watchAllFrontmatters() {
    return _frontmatterDao.watchAllFrontmatters().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<HabitFrontmatter>> getAllFrontmatters() async {
    final dataList = await _frontmatterDao.getAllFrontmatters();
    return dataList.map((data) => data.toEntity()).toList();
  }

  @override
  Future<HabitFrontmatter?> getLatestFrontmatter() async {
    final data = await _frontmatterDao.getLatestFrontmatter();
    return data?.toEntity();
  }

  @override
  Future<HabitFrontmatter?> getFrontmatterById(String id) async {
    final data = await _frontmatterDao.getFrontmatterById(id);
    return data?.toEntity();
  }

  @override
  Stream<List<HabitFrontmatter>> searchFrontmatters(String query) {
    return _frontmatterDao.searchFrontmatters(query).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<HabitFrontmatter>> watchFrontmattersByTag(String tag) {
    return _frontmatterDao.watchFrontmattersByTag(tag).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<HabitFrontmatter>> getRecentFrontmatters(int limit) async {
    final dataList = await _frontmatterDao.getRecentFrontmatters(limit);
    return dataList.map((data) => data.toEntity()).toList();
  }
}
