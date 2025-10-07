import '../../../../core/database/daos/goal_dao.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_level.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';

/// 目标仓库实现
///
/// Phase 1: 纯本地 Drift 存储
/// Phase 5+: 可扩展为云端同步
class GoalRepositoryImpl implements GoalRepository {
  final GoalDao _goalDao;

  GoalRepositoryImpl({
    required GoalDao goalDao,
  }) : _goalDao = goalDao;

  // ========== 基础 CRUD ==========

  @override
  Future<Goal?> getGoalById(String id) async {
    final data = await _goalDao.getGoalById(id);
    return data?.toEntity();
  }

  @override
  Future<void> createGoal(Goal goal) async {
    await _goalDao.insertGoal(goal.toData());
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    await _goalDao.updateGoal(goal.toData());
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _goalDao.deleteGoal(id);
  }

  // ========== 层级查询 ==========

  @override
  Stream<List<Goal>> watchRootGoals() {
    return _goalDao.watchRootGoals().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Goal>> watchChildGoals(String parentId) {
    return _goalDao.watchChildGoals(parentId).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Goal>> watchDescendantGoals(String parentPath) {
    return _goalDao.watchDescendantGoals(parentPath).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<Goal>> getAncestorGoals(String path) async {
    final dataList = await _goalDao.getAncestorGoals(path);
    return dataList.map((data) => data.toEntity()).toList();
  }

  // ========== 状态筛选 ==========

  @override
  Stream<List<Goal>> watchActiveGoals() {
    return _goalDao.watchActiveGoals().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Goal>> watchCompletedGoals() {
    return _goalDao.watchCompletedGoals().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Goal>> watchGoalsByLevel(GoalLevel level) {
    return _goalDao.watchGoalsByLevel(level.value).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  // ========== 状态更新 ==========

  @override
  Future<void> completeGoal(String id) async {
    await _goalDao.completeGoal(id);
  }

  @override
  Future<void> archiveGoal(String id) async {
    await _goalDao.archiveGoal(id);
  }

  @override
  Future<void> reactivateGoal(String id) async {
    await _goalDao.reactivateGoal(id);
  }

  @override
  Future<void> updateProgress(String id, int progress) async {
    await _goalDao.updateProgress(id, progress);
  }

  // ========== 搜索和统计 ==========

  @override
  Stream<List<Goal>> searchGoals(String query) {
    return _goalDao.searchGoals(query).map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<int> countActiveGoals() {
    return _goalDao.countActiveGoals();
  }

  @override
  Stream<List<Goal>> watchOverdueGoals() {
    return _goalDao.watchOverdueGoals().map(
          (list) => list.map((data) => data.toEntity()).toList(),
        );
  }

  @override
  Future<List<Goal>> getAllGoals() async {
    final dataList = await _goalDao.getAllGoals();
    return dataList.map((data) => data.toEntity()).toList();
  }
}
