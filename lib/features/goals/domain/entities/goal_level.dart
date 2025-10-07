/// 目标层级枚举
///
/// 基于《高效能人士的七个习惯》的层级目标体系
enum GoalLevel {
  /// 人生目标（最顶层）
  /// 示例："成为卓越的软件工程师"
  life('life', '人生目标', 0),

  /// 领域目标（第二层）
  /// 示例："职业发展"、"健康"、"家庭"
  domain('domain', '领域目标', 1),

  /// 年度目标（第三层）
  /// 示例："2025 年职业目标"
  year('year', '年度目标', 2),

  /// 季度目标（第四层）
  /// 示例："2025 Q1 目标"
  quarter('quarter', '季度目标', 3),

  /// 项目目标（最底层，可执行）
  /// 示例："完成悟道 MVP"
  project('project', '项目目标', 4);

  const GoalLevel(this.value, this.displayName, this.depth);

  /// 数据库存储值
  final String value;

  /// 显示名称
  final String displayName;

  /// 层级深度（0 最顶层）
  final int depth;

  /// 从数据库值转换
  static GoalLevel fromValue(String value) {
    return GoalLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => GoalLevel.project,
    );
  }

  /// 是否可以有子目标
  bool get canHaveChildren => this != GoalLevel.project;

  /// 下一层级
  GoalLevel? get nextLevel {
    final index = GoalLevel.values.indexOf(this);
    if (index < GoalLevel.values.length - 1) {
      return GoalLevel.values[index + 1];
    }
    return null;
  }

  /// 上一层级
  GoalLevel? get previousLevel {
    final index = GoalLevel.values.indexOf(this);
    if (index > 0) {
      return GoalLevel.values[index - 1];
    }
    return null;
  }
}
