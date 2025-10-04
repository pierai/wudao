import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_plan.freezed.dart';

/// 次日计划实体
///
/// 将习惯的"暗示"转化为次日行动计划
@freezed
sealed class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    /// 唯一标识符
    required String id,

    /// 计划日期
    required DateTime planDate,

    /// 关联的习惯 ID
    required String habitId,

    /// 暗示任务：基于习惯的 cue 生成的具体任务描述
    required String cueTask,

    /// 计划执行时间（可选）
    DateTime? scheduledTime,

    /// 优先级（0-10，数字越小优先级越高）
    required int priority,

    /// 是否已完成
    required bool isCompleted,

    /// 完成时间
    DateTime? completedAt,

    /// 关联的打卡记录 ID
    String? recordId,

    /// 创建时间
    required DateTime createdAt,
  }) = _DailyPlan;

  const DailyPlan._();

  /// 获取计划日期（忽略时间部分）
  DateTime get planDateOnly => DateTime(planDate.year, planDate.month, planDate.day);

  /// 是否为今日计划
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return planDateOnly == today;
  }

  /// 是否为明日计划
  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return planDateOnly == tomorrow;
  }

  /// 是否已过期
  bool get isOverdue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return planDateOnly.isBefore(today) && !isCompleted;
  }

  /// 优先级显示文本
  String get priorityDisplayText {
    if (priority == 0) return '最高';
    if (priority <= 3) return '高';
    if (priority <= 6) return '中';
    return '低';
  }

  /// 状态显示文本
  String get statusDisplayText {
    if (isCompleted) return '已完成';
    if (isOverdue) return '已逾期';
    return '待完成';
  }
}
