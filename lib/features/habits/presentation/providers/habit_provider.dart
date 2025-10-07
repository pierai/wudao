import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateProvider is legacy in Riverpod 3.0+, import from legacy module
// TODO: Migrate to NotifierProvider in future updates
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/notification_providers.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../../domain/entities/habit_stats.dart';
import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit_frontmatter.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../data/repositories/habit_repository_impl.dart';

// ========== 数据库 Provider ==========

/// 数据库单例 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// ========== Repository Providers ==========

/// 习惯仓库 Provider
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final reminderScheduler = ref.watch(reminderSchedulerServiceProvider);

  return HabitRepositoryImpl(
    habitDao: database.habitDao,
    recordDao: database.habitRecordDao,
    planDao: database.dailyPlanDao,
    frontmatterDao: database.frontmatterDao,
    reminderScheduler: reminderScheduler,
  );
});

// ========== 习惯相关 Providers ==========

/// 活跃习惯列表 Provider（响应式）
final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchActiveHabits();
});

/// 指定分类的习惯列表 Provider
final habitsByCategoryProvider =
    StreamProvider.family<List<Habit>, String>((ref, category) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchHabitsByCategory(category);
});

/// 搜索习惯 Provider
final searchHabitsProvider =
    StreamProvider.family<List<Habit>, String>((ref, query) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.searchHabits(query);
});

/// 习惯统计数据 Provider
final habitStatsProvider =
    FutureProvider.family<HabitStats, String>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitStats(habitId);
});

/// 今日是否已打卡 Provider
final hasTodayRecordProvider =
    FutureProvider.family<bool, String>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  final now = DateTime.now();
  return repository.hasRecordOnDate(habitId, now);
});

/// 习惯分类列表 Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getCategories();
});

/// 活跃习惯数量 Provider
final activeHabitsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.countActiveHabits();
});

// ========== 执行记录相关 Providers ==========

/// 指定习惯的执行记录列表 Provider
final habitRecordsProvider =
    StreamProvider.family<List<HabitRecord>, String>((ref, habitId) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchRecordsByHabitId(habitId);
});

/// 指定习惯的月度日历数据 Provider
final monthCalendarProvider = FutureProvider.family<
    Map<DateTime, List<HabitRecord>>,
    ({String habitId, int year, int month})>((ref, params) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getMonthCalendar(
    params.habitId,
    params.year,
    params.month,
  );
});

// ========== 次日计划相关 Providers ==========

/// 指定日期的计划列表 Provider
final plansByDateProvider =
    StreamProvider.family<List<DailyPlan>, DateTime>((ref, date) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchPlansByDate(date);
});

/// 今日计划列表 Provider
final todayPlansProvider = StreamProvider<List<DailyPlan>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  final today = DateTime.now();
  return repository.watchPlansByDate(today);
});

/// 指定习惯的未完成计划 Provider
final uncompletedPlansByHabitProvider =
    StreamProvider.family<List<DailyPlan>, String>((ref, habitId) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchUncompletedPlansByHabit(habitId);
});

/// 今日计划完成率 Provider
final todayPlanCompletionRateProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  final today = DateTime.now();
  return repository.getPlanCompletionRate(today);
});

// ========== Frontmatter 相关 Providers ==========

/// 所有 Frontmatters Provider
final allFrontmattersProvider = StreamProvider<List<HabitFrontmatter>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchAllFrontmatters();
});

/// 搜索 Frontmatters Provider
final searchFrontmattersProvider =
    StreamProvider.family<List<HabitFrontmatter>, String>((ref, query) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.searchFrontmatters(query);
});

/// 按标签筛选 Frontmatters Provider
final frontmattersByTagProvider =
    StreamProvider.family<List<HabitFrontmatter>, String>((ref, tag) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchFrontmattersByTag(tag);
});

/// 最新的 Frontmatter Provider
final latestFrontmatterProvider =
    FutureProvider<HabitFrontmatter?>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getLatestFrontmatter();
});

/// 所有可用标签 Provider（从所有 frontmatters 中提取）
final allAvailableTagsProvider = StreamProvider<List<String>>((ref) {
  final frontmattersAsync = ref.watch(allFrontmattersProvider);

  return frontmattersAsync.when(
    data: (frontmatters) {
      // 从所有 frontmatters 中提取所有标签
      final allTags = <String>{};
      for (final frontmatter in frontmatters) {
        allTags.addAll(frontmatter.tags);
      }
      // 按字母顺序排序
      final sortedTags = allTags.toList()..sort();
      return Stream.value(sortedTags);
    },
    loading: () => Stream.value(<String>[]),
    error: (error, stack) => Stream.error(error, stack),
  );
});

// ========== UI 状态 Providers ==========

/// 当前选中的习惯 ID Provider（用于详情页）
final selectedHabitIdProvider = StateProvider<String?>((ref) => null);

/// 当前选中的日期 Provider（用于日历页）
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 习惯列表排序方式 Provider
enum HabitSortType {
  createdTime, // 创建时间
  name, // 名称
  streak, // 连续天数
}

final habitSortTypeProvider =
    StateProvider<HabitSortType>((ref) => HabitSortType.createdTime);

/// 习惯列表筛选分类 Provider（null 表示显示全部）
final habitFilterCategoryProvider = StateProvider<String?>((ref) => null);

/// 核心习惯筛选类型
enum KeystoneFilterType {
  all, // 全部习惯
  keystoneOnly, // 仅核心习惯
  regularOnly, // 仅普通习惯
}

/// 核心习惯筛选 Provider
final keystoneFilterProvider =
    StateProvider<KeystoneFilterType>((ref) => KeystoneFilterType.all);

/// 根据核心习惯筛选条件过滤的活跃习惯列表 Provider
final filteredHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final habitsAsync = ref.watch(activeHabitsProvider);
  final filterType = ref.watch(keystoneFilterProvider);

  return habitsAsync.when(
    data: (habits) {
      switch (filterType) {
        case KeystoneFilterType.all:
          return Stream.value(habits);
        case KeystoneFilterType.keystoneOnly:
          return Stream.value(
              habits.where((habit) => habit.isKeystone).toList());
        case KeystoneFilterType.regularOnly:
          return Stream.value(
              habits.where((habit) => !habit.isKeystone).toList());
      }
    },
    loading: () => const Stream.empty(),
    error: (error, stack) => Stream.error(error, stack),
  );
});
