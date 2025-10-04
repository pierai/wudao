import 'package:drift/drift.dart';

/// 习惯 Frontmatter 表 - 记录习惯相关的感悟和笔记
///
/// Frontmatter 功能：受 Obsidian/Logseq 启发，使用 Markdown 记录深度思考
@DataClassName('HabitFrontmatterData')
class HabitFrontmatters extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 标题
  TextColumn get title => text().withLength(min: 1, max: 200)();

  /// Markdown 内容
  /// 用户可以记录关于习惯的深度思考、感悟、经验总结等
  TextColumn get content => text()();

  /// 标签列表（JSON 数组格式）
  /// 示例：["习惯养成", "自律", "运动"]
  /// 存储为 JSON 字符串：'["习惯养成","自律","运动"]'
  TextColumn get tags => text().withDefault(const Constant('[]'))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();

  /// 元数据（JSON 格式，可选）
  /// 用于存储额外的结构化信息
  /// 示例：{"mood": "happy", "energy": 8}
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
