import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habit_frontmatters_table.dart';

part 'frontmatter_dao.g.dart';

/// 习惯 Frontmatter 数据访问对象
///
/// 提供习惯感悟的 CRUD 操作和查询方法
@DriftAccessor(tables: [HabitFrontmatters])
class FrontmatterDao extends DatabaseAccessor<AppDatabase>
    with _$FrontmatterDaoMixin {
  FrontmatterDao(AppDatabase db) : super(db);

  /// 监听所有 Frontmatters（按更新时间倒序）
  Stream<List<HabitFrontmatterData>> watchAllFrontmatters() {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// 获取所有 Frontmatters
  Future<List<HabitFrontmatterData>> getAllFrontmatters() {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// 获取最新的 Frontmatter
  Future<HabitFrontmatterData?> getLatestFrontmatter() {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 根据 ID 获取 Frontmatter
  Future<HabitFrontmatterData?> getFrontmatterById(String id) {
    return (select(habitFrontmatters)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// 搜索 Frontmatters（按标题和内容）
  Stream<List<HabitFrontmatterData>> searchFrontmatters(String query) {
    return (select(habitFrontmatters)
          ..where((tbl) =>
              tbl.title.like('%$query%') | tbl.content.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// 按标签筛选 Frontmatters
  /// 注意：tags 字段存储的是 JSON 数组，这里使用 LIKE 查询
  Stream<List<HabitFrontmatterData>> watchFrontmattersByTag(String tag) {
    return (select(habitFrontmatters)
          ..where((tbl) => tbl.tags.like('%"$tag"%'))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// 插入 Frontmatter
  Future<int> insertFrontmatter(HabitFrontmatterData frontmatter) {
    return into(habitFrontmatters).insert(frontmatter);
  }

  /// 更新 Frontmatter
  Future<bool> updateFrontmatter(HabitFrontmatterData frontmatter) {
    return update(habitFrontmatters).replace(frontmatter);
  }

  /// 删除 Frontmatter
  Future<int> deleteFrontmatter(String id) {
    return (delete(habitFrontmatters)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 统计 Frontmatters 总数
  Future<int> countFrontmatters() async {
    final query = selectOnly(habitFrontmatters)
      ..addColumns([habitFrontmatters.id.count()]);

    final result = await query.getSingle();
    return result.read(habitFrontmatters.id.count()) ?? 0;
  }

  /// 获取最近创建的 N 条 Frontmatters
  Future<List<HabitFrontmatterData>> getRecentFrontmatters(int limit) {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取指定日期范围内创建的 Frontmatters
  Future<List<HabitFrontmatterData>> getFrontmattersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(habitFrontmatters)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(startDate) &
              tbl.createdAt.isSmallerThanValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}
