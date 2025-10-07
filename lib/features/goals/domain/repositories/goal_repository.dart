import '../entities/goal.dart';
import '../entities/goal_level.dart';

/// 目标仓库接口
///
/// 定义目标管理的所有业务逻辑接口
abstract class GoalRepository {
  // ========== 基础 CRUD ==========

  /// 根据 ID 获取目标
  Future<Goal?> getGoalById(String id);

  /// 创建目标
  Future<void> createGoal(Goal goal);

  /// 更新目标
  Future<void> updateGoal(Goal goal);

  /// 删除目标（级联删除子目标）
  Future<void> deleteGoal(String id);

  // ========== 层级查询 ==========

  /// 监听所有根目标（人生目标）
  Stream<List<Goal>> watchRootGoals();

  /// 监听指定目标的子目标
  Stream<List<Goal>> watchChildGoals(String parentId);

  /// 监听指定路径下的所有子孙目标
  Stream<List<Goal>> watchDescendantGoals(String parentPath);

  /// 获取指定目标的所有祖先目标
  Future<List<Goal>> getAncestorGoals(String path);

  // ========== 状态筛选 ==========

  /// 监听所有活跃目标
  Stream<List<Goal>> watchActiveGoals();

  /// 监听所有已完成目标
  Stream<List<Goal>> watchCompletedGoals();

  /// 监听指定层级的活跃目标
  Stream<List<Goal>> watchGoalsByLevel(GoalLevel level);

  // ========== 状态更新 ==========

  /// 标记目标为已完成
  Future<void> completeGoal(String id);

  /// 归档目标
  Future<void> archiveGoal(String id);

  /// 重新激活目标
  Future<void> reactivateGoal(String id);

  /// 更新目标进度
  Future<void> updateProgress(String id, int progress);

  // ========== 搜索和统计 ==========

  /// 搜索目标
  Stream<List<Goal>> searchGoals(String query);

  /// 统计活跃目标数量
  Future<int> countActiveGoals();

  /// 监听逾期目标
  Stream<List<Goal>> watchOverdueGoals();

  /// 获取所有目标（用于数据导出）
  Future<List<Goal>> getAllGoals();
}
