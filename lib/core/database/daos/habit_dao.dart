import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habits_table.dart';

part 'habit_dao.g.dart';

/// 习惯数据访问对象
///
/// 提供习惯的 CRUD 操作和查询方法
@DriftAccessor(tables: [Habits])
class HabitDao extends DatabaseAccessor<AppDatabase> with _$HabitDaoMixin {
  HabitDao(AppDatabase db) : super(db);

  /// 监听所有活跃习惯（按创建时间倒序）
  Stream<List<HabitData>> watchActiveHabits() {
    return (select(habits)
          ..where((tbl) => tbl.isActive.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// 监听指定分类的活跃习惯
  Stream<List<HabitData>> watchHabitsByCategory(String category) {
    return (select(habits)
          ..where((tbl) =>
              tbl.isActive.equals(true) &
              tbl.deletedAt.isNull() &
              tbl.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// 根据 ID 获取习惯
  Future<HabitData?> getHabitById(String id) {
    return (select(habits)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// 搜索习惯（按名称、暗示、行为、奖赏）
  Stream<List<HabitData>> searchHabits(String query) {
    return (select(habits)
          ..where((tbl) =>
              tbl.isActive.equals(true) &
              tbl.deletedAt.isNull() &
              (tbl.name.like('%$query%') |
                  tbl.cue.like('%$query%') |
                  tbl.routine.like('%$query%') |
                  tbl.reward.like('%$query%')))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// 插入新习惯
  Future<int> insertHabit(HabitData habit) {
    return into(habits).insert(habit);
  }

  /// 更新习惯
  Future<bool> updateHabit(HabitData habit) {
    return update(habits).replace(habit);
  }

  /// 软删除习惯（设置 deletedAt 时间戳）
  Future<int> softDeleteHabit(String id) {
    return (update(habits)..where((tbl) => tbl.id.equals(id))).write(
      HabitsCompanion(
        deletedAt: Value(DateTime.now()),
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 永久删除习惯（谨慎使用！会级联删除所有相关记录）
  Future<int> hardDeleteHabit(String id) {
    return (delete(habits)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 归档/取消归档习惯
  Future<int> toggleArchive(String id, bool isActive) {
    return (update(habits)..where((tbl) => tbl.id.equals(id))).write(
      HabitsCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 获取所有分类列表（去重）
  Future<List<String>> getCategories() async {
    final query = selectOnly(habits, distinct: true)
      ..addColumns([habits.category])
      ..where(habits.category.isNotNull() & habits.deletedAt.isNull());

    final results = await query.get();
    return results
        .map((row) => row.read(habits.category))
        .where((category) => category != null)
        .cast<String>()
        .toList();
  }

  /// 统计活跃习惯数量
  Future<int> countActiveHabits() async {
    final query = selectOnly(habits)
      ..addColumns([habits.id.count()])
      ..where(habits.isActive.equals(true) & habits.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(habits.id.count()) ?? 0;
  }

  /// 获取所有习惯（包括已删除的，可选）
  Future<List<HabitData>> getAllHabits({bool includeDeleted = false}) {
    final query = select(habits)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (!includeDeleted) {
      query.where((tbl) => tbl.deletedAt.isNull());
    }

    return query.get();
  }
}
