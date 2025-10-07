import 'package:drift/drift.dart';

/// 目标表 - 层级目标管理
///
/// 基于《高效能人士的七个习惯》第二习惯"以终为始"
/// 支持 5 层目标层级：人生 → 领域 → 年度 → 季度 → 项目
@DataClassName('GoalData')
class Goals extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 目标标题
  TextColumn get title => text().withLength(min: 1, max: 200)();

  /// 目标描述（可选）
  TextColumn get description => text().nullable()();

  /// 目标层级（life/domain/year/quarter/project）
  TextColumn get level => text()();

  /// 父目标 ID（外键，可选，级联删除）
  /// 人生目标的 parentId 为 null
  TextColumn get parentId => text()
      .nullable()
      .references(Goals, #id, onDelete: KeyAction.cascade)();

  /// 层级路径（ltree 格式，如 "life.1.2025.q1"）
  /// Flutter 本地使用字符串存储，后端 PostgreSQL 使用 ltree 类型
  TextColumn get path => text()();

  /// 目标状态（active/completed/archived）
  TextColumn get status => text().withDefault(const Constant('active'))();

  /// 优先级（1-5，1 最高，5 最低）
  IntColumn get priority => integer().withDefault(const Constant(3))();

  /// 进度百分比（0-100）
  IntColumn get progress => integer().withDefault(const Constant(0))();

  /// 开始日期（可选）
  DateTimeColumn get startDate => dateTime().nullable()();

  /// 截止日期（可选）
  DateTimeColumn get deadline => dateTime().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// 完成时间
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// 归档时间
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {path}, // 路径唯一
      ];
}
