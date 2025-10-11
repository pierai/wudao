import 'package:drift/drift.dart';

/// 习惯表 - 基于《习惯的力量》理论的习惯循环模型
///
/// 包含习惯循环三要素：暗示（Cue）、惯常行为（Routine）、奖赏（Reward）
@DataClassName('HabitData')
class Habits extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 习惯名称
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// 暗示：触发习惯的环境或情境信号（可选）
  /// 示例："早上起床后，看到书包放在椅子上"
  TextColumn get cue => text().withLength(max: 500).nullable()();

  /// 惯常行为：习惯性执行的动作
  /// 示例："拿起书包去图书馆"
  TextColumn get routine => text().withLength(min: 1, max: 500)();

  /// 原惯常行为：仅用于习惯替代类型（REPLACEMENT）
  /// 示例："喝奶茶" -> 替代为 -> "喝酸奶"
  TextColumn get oldRoutine => text().withLength(max: 500).nullable()();

  /// 奖赏：行为带来的满足感或收益（可选）
  /// 示例："自律的实现让我精神满足"
  TextColumn get reward => text().withLength(max: 500).nullable()();

  /// 习惯类型：POSITIVE（正向习惯）、CORE（核心习惯）或 REPLACEMENT（习惯替代）
  TextColumn get type => text()();

  /// 分类（可选）：运动、学习、健康、工作等
  TextColumn get category => text().withLength(max: 50).nullable()();

  /// 备注说明
  TextColumn get notes => text().nullable()();

  /// 是否活跃（用于软删除和归档）
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();

  /// 软删除时间（null 表示未删除）
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    // 确保习惯替代类型必须填写 oldRoutine
    "CHECK (type != 'REPLACEMENT' OR old_routine IS NOT NULL)",
  ];
}
