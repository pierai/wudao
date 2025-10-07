import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/goals_table.dart';

part 'goal_dao.g.dart';

/// 目标数据访问对象
///
/// 提供层级目标的 CRUD 操作和查询方法
@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  // ========== 基础 CRUD 操作 ==========

  /// 根据 ID 获取目标
  Future<GoalData?> getGoalById(String id) {
    return (select(goals)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// 插入单个目标
  Future<int> insertGoal(GoalData goal) {
    return into(goals).insert(goal);
  }

  /// 更新目标
  Future<bool> updateGoal(GoalData goal) {
    return update(goals).replace(goal);
  }

  /// 删除目标（级联删除子目标）
  Future<int> deleteGoal(String id) {
    return (delete(goals)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ========== 层级查询 ==========

  /// 获取所有根目标（人生目标）
  Stream<List<GoalData>> watchRootGoals() {
    return (select(goals)
          ..where((tbl) => tbl.parentId.isNull())
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// 获取指定目标的所有子目标
  Stream<List<GoalData>> watchChildGoals(String parentId) {
    return (select(goals)
          ..where((tbl) => tbl.parentId.equals(parentId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// 获取指定路径下的所有子孙目标（包括子目标的子目标）
  /// 使用路径前缀匹配：path LIKE 'parent.path.%'
  Stream<List<GoalData>> watchDescendantGoals(String parentPath) {
    return (select(goals)
          ..where((tbl) => tbl.path.like('$parentPath.%'))
          ..orderBy([
            (t) => OrderingTerm.asc(t.path),
          ]))
        .watch();
  }

  /// 获取指定目标的所有祖先目标
  /// 通过路径解析实现
  Future<List<GoalData>> getAncestorGoals(String path) async {
    final parts = path.split('.');
    final ancestorPaths = <String>[];

    for (var i = 1; i < parts.length; i++) {
      ancestorPaths.add(parts.sublist(0, i).join('.'));
    }

    if (ancestorPaths.isEmpty) return [];

    return (select(goals)
          ..where((tbl) => tbl.path.isIn(ancestorPaths))
          ..orderBy([(t) => OrderingTerm.asc(t.path)]))
        .get();
  }

  // ========== 状态筛选 ==========

  /// 监听所有活跃目标
  Stream<List<GoalData>> watchActiveGoals() {
    return (select(goals)
          ..where((tbl) => tbl.status.equals('active'))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// 监听所有已完成目标
  Stream<List<GoalData>> watchCompletedGoals() {
    return (select(goals)
          ..where((tbl) => tbl.status.equals('completed'))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .watch();
  }

  /// 获取指定层级的所有活跃目标
  Stream<List<GoalData>> watchGoalsByLevel(String level) {
    return (select(goals)
          ..where((tbl) =>
              tbl.level.equals(level) & tbl.status.equals('active'))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  // ========== 状态更新 ==========

  /// 标记目标为已完成
  Future<int> completeGoal(String id) {
    return (update(goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        status: const Value('completed'),
        progress: const Value(100),
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 归档目标
  Future<int> archiveGoal(String id) {
    return (update(goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        status: const Value('archived'),
        archivedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 重新激活目标
  Future<int> reactivateGoal(String id) {
    return (update(goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        status: const Value('active'),
        archivedAt: const Value(null),
        completedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 更新目标进度
  Future<int> updateProgress(String id, int progress) {
    return (update(goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        progress: Value(progress),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ========== 搜索和统计 ==========

  /// 搜索目标（按标题或描述）
  Stream<List<GoalData>> searchGoals(String query) {
    final pattern = '%$query%';
    return (select(goals)
          ..where((tbl) =>
              tbl.title.like(pattern) |
              (tbl.description.isNotNull() & tbl.description.like(pattern)))
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// 统计活跃目标数量
  Future<int> countActiveGoals() async {
    final query = selectOnly(goals)
      ..addColumns([goals.id.count()])
      ..where(goals.status.equals('active'));

    final result = await query.getSingle();
    return result.read(goals.id.count()) ?? 0;
  }

  /// 获取逾期目标
  Stream<List<GoalData>> watchOverdueGoals() {
    final now = DateTime.now();
    return (select(goals)
          ..where((tbl) =>
              tbl.deadline.isSmallerThanValue(now) &
              tbl.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.asc(t.deadline)]))
        .watch();
  }

  /// 获取所有目标（用于数据导出）
  Future<List<GoalData>> getAllGoals() {
    return (select(goals)..orderBy([(t) => OrderingTerm.asc(t.path)])).get();
  }
}
