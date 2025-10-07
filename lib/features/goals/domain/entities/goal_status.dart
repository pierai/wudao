/// 目标状态枚举
enum GoalStatus {
  /// 活跃状态（正在进行）
  active('active', '进行中'),

  /// 已完成
  completed('completed', '已完成'),

  /// 已归档（不再关注）
  archived('archived', '已归档');

  const GoalStatus(this.value, this.displayName);

  /// 数据库存储值
  final String value;

  /// 显示名称
  final String displayName;

  /// 从数据库值转换
  static GoalStatus fromValue(String value) {
    return GoalStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => GoalStatus.active,
    );
  }
}

/// GoalStatus 扩展方法
extension GoalStatusX on GoalStatus {
  /// 是否活跃
  bool get isActive => this == GoalStatus.active;

  /// 是否已完成
  bool get isCompleted => this == GoalStatus.completed;

  /// 是否已归档
  bool get isArchived => this == GoalStatus.archived;
}
