import 'package:freezed_annotation/freezed_annotation.dart';
import 'plan_completion_status.dart';

part 'daily_plan.freezed.dart';
part 'daily_plan.g.dart';

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

    /// 计划完成状态
    @Default(PlanCompletionStatus.pending) PlanCompletionStatus status,

    /// 暗示完成时间
    DateTime? cueCompletedAt,

    /// 打卡时间
    DateTime? checkedInAt,

    /// 关联的打卡记录 ID
    String? recordId,

    /// 创建时间
    required DateTime createdAt,

    /// 更新时间
    DateTime? updatedAt,

    // ==================== 提醒功能字段 ====================
    /// 是否启用提醒
    @Default(true) bool reminderEnabled,

    /// 提前提醒分钟数（0=准时, 5=提前5分钟, 10=提前10分钟, 15=提前15分钟）
    @Default(0) int reminderMinutesBefore,

    // ==================== 废弃字段(向后兼容) ====================
    /// @deprecated 使用 status 替代
    @Deprecated('Use status instead') @Default(false) bool isCompleted,

    /// @deprecated 使用 checkedInAt 替代
    @Deprecated('Use checkedInAt instead') DateTime? completedAt,
  }) = _DailyPlan;

  const DailyPlan._();

  factory DailyPlan.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanFromJson(json);

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
    return planDateOnly.isBefore(today) && status.isPending;
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
    switch (status) {
      case PlanCompletionStatus.pending:
        return isOverdue ? '已逾期' : '待执行';
      case PlanCompletionStatus.cueCompleted:
        return '暗示已完成';
      case PlanCompletionStatus.checkedIn:
        return '已打卡';
      case PlanCompletionStatus.skipped:
        return '已跳过';
    }
  }

  /// 是否待执行
  bool get isPending => status.isPending;

  /// 是否暗示已完成
  bool get isCueCompleted => status.isCueCompleted;

  /// 是否已打卡
  bool get isCheckedIn => status.isCheckedIn;

  /// 是否已跳过
  bool get isSkipped => status.isSkipped;

  /// 是否可以操作(明日计划不可操作)
  bool get isActionable => isToday || isOverdue;
}
