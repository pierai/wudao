import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateProvider is legacy in Riverpod 3.0+, import from legacy module
// TODO: Migrate to NotifierProvider in future updates
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../core/providers/database_provider.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_level.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../data/repositories/goal_repository_impl.dart';

// ========== Repository Provider ==========

/// 目标仓库 Provider
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return GoalRepositoryImpl(
    goalDao: database.goalDao,
  );
});

// ========== 目标相关 Providers ==========

/// 根目标（人生目标）列表 Provider
final rootGoalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchRootGoals();
});

/// 活跃目标列表 Provider
final activeGoalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchActiveGoals();
});

/// 已完成目标列表 Provider
final completedGoalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchCompletedGoals();
});

/// 指定层级的活跃目标 Provider
final goalsByLevelProvider =
    StreamProvider.family<List<Goal>, GoalLevel>((ref, level) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchGoalsByLevel(level);
});

/// 指定父目标的子目标 Provider
final childGoalsProvider =
    StreamProvider.family<List<Goal>, String>((ref, parentId) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchChildGoals(parentId);
});

/// 逾期目标列表 Provider
final overdueGoalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.watchOverdueGoals();
});

/// 搜索目标 Provider
final searchGoalsProvider =
    StreamProvider.family<List<Goal>, String>((ref, query) {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.searchGoals(query);
});

/// 活跃目标数量 Provider
final activeGoalsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.countActiveGoals();
});

// ========== UI 状态 Providers ==========

/// 当前选中的目标 ID Provider
final selectedGoalIdProvider = StateProvider<String?>((ref) => null);

/// 当前显示的目标层级 Provider
final currentGoalLevelProvider =
    StateProvider<GoalLevel>((ref) => GoalLevel.life);

/// 目标筛选状态 Provider（all/active/completed/overdue）
enum GoalFilterType {
  all,
  active,
  completed,
  overdue,
}

final goalFilterTypeProvider =
    StateProvider<GoalFilterType>((ref) => GoalFilterType.active);
