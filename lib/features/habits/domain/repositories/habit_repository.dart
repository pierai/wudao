import '../entities/habit.dart';
import '../entities/habit_record.dart';
import '../entities/habit_stats.dart';
import '../entities/daily_plan.dart';
import '../entities/habit_frontmatter.dart';

/// 习惯仓库接口
///
/// 定义习惯追踪模块的所有业务操作
/// 为未来云端同步预留扩展性（Phase 5+）
abstract class HabitRepository {
  // ========== 习惯管理 ==========

  /// 创建新习惯
  Future<Habit> createHabit(Habit habit);

  /// 更新习惯
  Future<void> updateHabit(Habit habit);

  /// 软删除习惯
  Future<void> deleteHabit(String id);

  /// 永久删除习惯（谨慎使用！）
  Future<void> hardDeleteHabit(String id);

  /// 监听所有活跃习惯
  Stream<List<Habit>> watchActiveHabits();

  /// 监听指定分类的习惯
  Stream<List<Habit>> watchHabitsByCategory(String category);

  /// 根据 ID 获取习惯
  Future<Habit?> getHabitById(String id);

  /// 搜索习惯
  Stream<List<Habit>> searchHabits(String query);

  /// 归档/取消归档习惯
  Future<void> toggleArchive(String id, bool isActive);

  /// 获取所有分类列表
  Future<List<String>> getCategories();

  /// 统计活跃习惯数量
  Future<int> countActiveHabits();

  /// 获取所有习惯（包括已删除的，可选）
  Future<List<Habit>> getAllHabits({bool includeDeleted = false});

  // ========== 习惯关联管理 ==========

  /// 添加习惯关联（将普通习惯关联到核心习惯）
  Future<void> addHabitAssociation({
    required String keystoneHabitId,
    required String associatedHabitId,
  });

  /// 删除习惯关联
  Future<void> removeHabitAssociation({
    required String keystoneHabitId,
    required String associatedHabitId,
  });

  /// 获取核心习惯的所有伴随习惯
  Future<List<Habit>> getAssociatedHabits(String keystoneHabitId);

  /// 监听核心习惯的所有伴随习惯
  Stream<List<Habit>> watchAssociatedHabits(String keystoneHabitId);

  /// 检查习惯是否已关联
  Future<bool> isHabitAssociated({
    required String keystoneHabitId,
    required String associatedHabitId,
  });

  /// 获取未关联到任何核心习惯的习惯列表
  /// 仅返回 type != core 的习惯
  Stream<List<Habit>> watchUnassociatedHabits();

  // ========== 执行记录管理 ==========

  /// 记录习惯执行（打卡）
  Future<void> recordExecution(HabitRecord record);

  /// 更新打卡记录
  Future<void> updateRecord(HabitRecord record);

  /// 删除打卡记录
  Future<void> deleteRecord(String id);

  /// 监听指定习惯的所有记录
  Stream<List<HabitRecord>> watchRecordsByHabitId(String habitId);

  /// 获取指定习惯的所有记录
  Future<List<HabitRecord>> getRecordsByHabitId(String habitId);

  /// 获取指定日期范围内的记录
  Future<List<HabitRecord>> getRecordsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  );

  /// 检查指定日期是否已打卡
  Future<bool> hasRecordOnDate(String habitId, DateTime date);

  /// 获取指定日期的打卡记录
  Future<HabitRecord?> getRecordOnDate(String habitId, DateTime date);

  /// 获取指定月份的打卡日历数据
  Future<Map<DateTime, List<HabitRecord>>> getMonthCalendar(
    String habitId,
    int year,
    int month,
  );

  // ========== 统计信息 ==========

  /// 获取习惯统计数据
  Future<HabitStats> getHabitStats(String habitId);

  /// 获取当前连续天数
  Future<int> getCurrentStreak(String habitId);

  /// 获取最佳连续记录
  Future<int> getBestStreak(String habitId);

  /// 获取完成率
  Future<double> getCompletionRate(String habitId);

  // ========== 次日计划管理 ==========

  /// 创建次日计划
  Future<void> createDailyPlan(DailyPlan plan);

  /// 批量创建次日计划
  Future<void> createDailyPlans(List<DailyPlan> plans);

  /// 更新次日计划
  Future<void> updateDailyPlan(DailyPlan plan);

  // ========== 次日计划状态管理 (Phase 2 新增) ==========

  /// 标记暗示已完成 (pending → cueCompleted)
  Future<void> markCueCompleted(String planId);

  /// 取消暗示完成 (cueCompleted → pending)
  Future<void> markCueIncomplete(String planId);

  /// 标记计划已打卡 (cueCompleted → checkedIn)
  /// @param planId 计划 ID
  /// @param recordId 关联的打卡记录 ID
  Future<void> markPlanCheckedIn(String planId, String recordId);

  /// 标记计划已跳过 (pending → skipped)
  /// 当用户在习惯列表直接打卡时调用
  Future<void> markPlanSkipped(String planId);

  /// 取消打卡 (checkedIn → cueCompleted)
  /// 同时删除关联的打卡记录
  Future<void> cancelCheckIn(String recordId);

  /// 检查今日是否已打卡
  Future<bool> hasTodayRecord(String habitId, DateTime date);

  /// 获取今日打卡记录
  Future<HabitRecord?> getTodayRecord(String habitId, DateTime date);

  /// 同步计划状态(习惯列表打卡后调用)
  /// 自动将关联的计划标记为 skipped 或 checkedIn
  Future<void> syncPlanStatusAfterCheckIn(
    String habitId,
    DateTime date,
    String recordId,
  );

  /// 根据习惯ID和日期获取计划
  Future<DailyPlan?> getPlanByHabitAndDate(String habitId, DateTime date);

  // ========== 废弃方法(向后兼容) ==========

  /// @deprecated 使用 markPlanCheckedIn 替代
  @Deprecated('Use markPlanCheckedIn instead')
  Future<void> completeDailyPlan(String planId, String? recordId);

  /// @deprecated 使用 markCueIncomplete 替代
  @Deprecated('Use markCueIncomplete instead')
  Future<void> uncompleteDailyPlan(String planId);

  /// 删除次日计划
  Future<void> deleteDailyPlan(String planId);

  /// 监听指定日期的所有计划
  Stream<List<DailyPlan>> watchPlansByDate(DateTime date);

  /// 获取指定日期的所有计划
  Future<List<DailyPlan>> getPlansByDate(DateTime date);

  /// 监听指定习惯的未完成计划
  Stream<List<DailyPlan>> watchUncompletedPlansByHabit(String habitId);

  /// 获取指定习惯的今日计划
  Future<DailyPlan?> getTodayPlanByHabit(String habitId);

  /// 统计指定日期的计划完成率
  Future<double> getPlanCompletionRate(DateTime date);

  /// 清理旧计划（指定日期之前）
  Future<void> deleteOldPlans(DateTime beforeDate);

  /// 获取所有计划
  Future<List<DailyPlan>> getAllPlans();

  // ========== Frontmatter 管理 ==========

  /// 创建 Frontmatter
  Future<void> createFrontmatter(HabitFrontmatter frontmatter);

  /// 更新 Frontmatter
  Future<void> updateFrontmatter(HabitFrontmatter frontmatter);

  /// 删除 Frontmatter
  Future<void> deleteFrontmatter(String id);

  /// 监听所有 Frontmatters
  Stream<List<HabitFrontmatter>> watchAllFrontmatters();

  /// 获取所有 Frontmatters
  Future<List<HabitFrontmatter>> getAllFrontmatters();

  /// 获取最新的 Frontmatter
  Future<HabitFrontmatter?> getLatestFrontmatter();

  /// 根据 ID 获取 Frontmatter
  Future<HabitFrontmatter?> getFrontmatterById(String id);

  /// 搜索 Frontmatters
  Stream<List<HabitFrontmatter>> searchFrontmatters(String query);

  /// 按标签筛选 Frontmatters
  Stream<List<HabitFrontmatter>> watchFrontmattersByTag(String tag);

  /// 获取最近的 N 条 Frontmatters
  Future<List<HabitFrontmatter>> getRecentFrontmatters(int limit);
}
