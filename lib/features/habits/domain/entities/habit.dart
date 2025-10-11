import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit_category.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

/// 习惯实体 - 基于《习惯的力量》理论
///
/// 包含习惯循环三要素：暗示（Cue）、惯常行为（Routine）、奖赏（Reward）
@freezed
sealed class Habit with _$Habit {
  const factory Habit({
    /// 唯一标识符
    required String id,

    /// 习惯名称
    required String name,

    /// 暗示：触发习惯的环境或情境信号（可选）
    String? cue,

    /// 惯常行为：习惯性执行的动作
    required String routine,

    /// 原惯常行为（仅用于习惯替代类型）
    String? oldRoutine,

    /// 奖赏：行为带来的满足感或收益（可选）
    String? reward,

    /// 习惯类型
    required HabitType type,

    /// 分类（可选）- 生活、工作、运动
    HabitCategory? category,

    /// 备注说明
    String? notes,

    /// 是否活跃
    required bool isActive,

    /// 创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 软删除时间
    DateTime? deletedAt,
  }) = _Habit;

  const Habit._();

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  /// 是否为习惯替代类型
  bool get isReplacement => type == HabitType.replacement;

  /// 是否为正向习惯类型
  bool get isPositive => type == HabitType.positive;

  /// 是否为核心习惯类型
  bool get isCore => type == HabitType.core;

  /// 习惯类型字符串表示
  String get typeString {
    switch (type) {
      case HabitType.positive:
        return 'POSITIVE';
      case HabitType.core:
        return 'CORE';
      case HabitType.replacement:
        return 'REPLACEMENT';
    }
  }

  /// 习惯类型显示文本
  String get typeDisplayText {
    switch (type) {
      case HabitType.positive:
        return '正向习惯';
      case HabitType.core:
        return '核心习惯';
      case HabitType.replacement:
        return '习惯替代';
    }
  }
}

/// 习惯类型枚举
enum HabitType {
  /// 正向习惯：建立新的良好习惯
  positive,

  /// 核心习惯：能引发连锁反应，带动其他习惯的形成
  core,

  /// 习惯替代：改变不良习惯（保持相同的暗示和奖赏，改变惯常行为）
  replacement,
}

/// 扩展：从字符串创建 HabitType
extension HabitTypeX on HabitType {
  static HabitType fromString(String value) {
    return HabitType.values.firstWhere(
      (type) => type.name.toUpperCase() == value.toUpperCase(),
      orElse: () => HabitType.positive,
    );
  }

  /// 获取类型的显示文本
  String get displayText {
    switch (this) {
      case HabitType.positive:
        return '正向习惯';
      case HabitType.core:
        return '核心习惯';
      case HabitType.replacement:
        return '习惯替代';
    }
  }

  /// 获取类型的图标
  String get icon {
    switch (this) {
      case HabitType.positive:
        return '✅';
      case HabitType.core:
        return '💎';
      case HabitType.replacement:
        return '🔄';
    }
  }

  /// 获取带图标的显示文本
  String get displayTextWithIcon {
    return '$icon $displayText';
  }
}
