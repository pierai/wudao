import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habit_associations_table.dart';
import '../tables/habits_table.dart';

part 'habit_association_dao.g.dart';

/// 习惯关联数据访问对象
///
/// 提供核心习惯与伴随习惯关联的 CRUD 操作
@DriftAccessor(tables: [HabitAssociations, Habits])
class HabitAssociationDao extends DatabaseAccessor<AppDatabase>
    with _$HabitAssociationDaoMixin {
  HabitAssociationDao(AppDatabase db) : super(db);

  /// 添加习惯关联
  Future<void> addAssociation({
    required String keystoneHabitId,
    required String associatedHabitId,
  }) async {
    final association = HabitAssociationsCompanion.insert(
      id: 'assoc_${DateTime.now().millisecondsSinceEpoch}',
      keystoneHabitId: keystoneHabitId,
      associatedHabitId: associatedHabitId,
      createdAt: DateTime.now(),
    );

    await into(habitAssociations).insert(
      association,
      mode: InsertMode.insertOrIgnore, // 如果已存在则忽略
    );
  }

  /// 删除习惯关联
  Future<int> removeAssociation({
    required String keystoneHabitId,
    required String associatedHabitId,
  }) {
    return (delete(habitAssociations)
          ..where((tbl) =>
              tbl.keystoneHabitId.equals(keystoneHabitId) &
              tbl.associatedHabitId.equals(associatedHabitId)))
        .go();
  }

  /// 获取核心习惯的所有伴随习惯ID列表
  Future<List<String>> getAssociatedHabitIds(String keystoneHabitId) async {
    final query = select(habitAssociations)
      ..where((tbl) => tbl.keystoneHabitId.equals(keystoneHabitId));

    final results = await query.get();
    return results.map((e) => e.associatedHabitId).toList();
  }

  /// 监听核心习惯的伴随习惯ID列表
  Stream<List<String>> watchAssociatedHabitIds(String keystoneHabitId) {
    final query = select(habitAssociations)
      ..where((tbl) => tbl.keystoneHabitId.equals(keystoneHabitId));

    return query.watch().map((list) => list.map((e) => e.associatedHabitId).toList());
  }

  /// 获取核心习惯的所有伴随习惯详情
  Future<List<HabitData>> getAssociatedHabits(String keystoneHabitId) async {
    final query = select(habitAssociations).join([
      innerJoin(
        habits,
        habits.id.equalsExp(habitAssociations.associatedHabitId),
      ),
    ])
      ..where(habitAssociations.keystoneHabitId.equals(keystoneHabitId));

    final results = await query.get();
    return results.map((row) => row.readTable(habits)).toList();
  }

  /// 监听核心习惯的所有伴随习惯详情
  Stream<List<HabitData>> watchAssociatedHabits(String keystoneHabitId) {
    final query = select(habitAssociations).join([
      innerJoin(
        habits,
        habits.id.equalsExp(habitAssociations.associatedHabitId),
      ),
    ])
      ..where(
        habitAssociations.keystoneHabitId.equals(keystoneHabitId) &
            habits.isActive.equals(true) &
            habits.deletedAt.isNull(),
      );

    return query.watch().map(
          (rows) => rows.map((row) => row.readTable(habits)).toList(),
        );
  }

  /// 删除核心习惯的所有关联
  Future<int> removeAllAssociationsForKeystoneHabit(String keystoneHabitId) {
    return (delete(habitAssociations)
          ..where((tbl) => tbl.keystoneHabitId.equals(keystoneHabitId)))
        .go();
  }

  /// 删除涉及某个习惯的所有关联（作为核心习惯或伴随习惯）
  Future<void> removeAllAssociationsForHabit(String habitId) async {
    // 作为核心习惯的关联
    await (delete(habitAssociations)
          ..where((tbl) => tbl.keystoneHabitId.equals(habitId)))
        .go();

    // 作为伴随习惯的关联
    await (delete(habitAssociations)
          ..where((tbl) => tbl.associatedHabitId.equals(habitId)))
        .go();
  }

  /// 检查习惯是否已关联到某个核心习惯
  Future<bool> isAssociated({
    required String keystoneHabitId,
    required String associatedHabitId,
  }) async {
    final query = select(habitAssociations)
      ..where((tbl) =>
          tbl.keystoneHabitId.equals(keystoneHabitId) &
          tbl.associatedHabitId.equals(associatedHabitId))
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 获取所有关联关系
  Future<List<HabitAssociationData>> getAllAssociations() {
    return select(habitAssociations).get();
  }

  /// 监听未关联到任何核心习惯的习惯列表
  /// 返回所有活跃的、type != CORE 且未被关联的习惯
  Stream<List<HabitData>> watchUnassociatedHabits() {
    // 使用 LEFT JOIN 查找未被关联的习惯
    final query = select(habits).join([
      leftOuterJoin(
        habitAssociations,
        habitAssociations.associatedHabitId.equalsExp(habits.id),
      ),
    ])
      ..where(
        habits.isActive.equals(true) &
            habits.deletedAt.isNull() &
            habits.type.equals('CORE').not() &
            habitAssociations.id.isNull(), // 未被关联
      )
      ..orderBy([OrderingTerm.asc(habits.createdAt)]);

    return query.watch().map(
          (rows) => rows.map((row) => row.readTable(habits)).toList(),
        );
  }
}
