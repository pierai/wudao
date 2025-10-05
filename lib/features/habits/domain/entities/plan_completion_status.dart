/// 次日计划完成状态
///
/// 基于习惯循环理论:
/// - pending: 待执行(初始状态)
/// - cueCompleted: 暗示已完成,但未执行惯常行为
/// - checkedIn: 已打卡(完整执行习惯循环)
/// - skipped: 已跳过(在习惯列表直接打卡,未通过计划暗示触发)
enum PlanCompletionStatus {
  /// 待执行
  pending,

  /// 暗示已完成(未打卡)
  cueCompleted,

  /// 已打卡(通过计划打卡)
  checkedIn,

  /// 已跳过(在习惯列表直接打卡)
  skipped,
}

/// 扩展方法
extension PlanCompletionStatusX on PlanCompletionStatus {
  /// 是否待执行
  bool get isPending => this == PlanCompletionStatus.pending;

  /// 是否暗示已完成
  bool get isCueCompleted => this == PlanCompletionStatus.cueCompleted;

  /// 是否已打卡
  bool get isCheckedIn => this == PlanCompletionStatus.checkedIn;

  /// 是否已跳过
  bool get isSkipped => this == PlanCompletionStatus.skipped;

  /// 转换为数据库存储值
  String toDbValue() {
    switch (this) {
      case PlanCompletionStatus.pending:
        return 'pending';
      case PlanCompletionStatus.cueCompleted:
        return 'cueCompleted';
      case PlanCompletionStatus.checkedIn:
        return 'checkedIn';
      case PlanCompletionStatus.skipped:
        return 'skipped';
    }
  }

  /// 从数据库值解析
  static PlanCompletionStatus fromDbValue(String value) {
    switch (value) {
      case 'pending':
        return PlanCompletionStatus.pending;
      case 'cueCompleted':
        return PlanCompletionStatus.cueCompleted;
      case 'checkedIn':
        return PlanCompletionStatus.checkedIn;
      case 'skipped':
        return PlanCompletionStatus.skipped;
      default:
        return PlanCompletionStatus.pending;
    }
  }
}
