/// 习惯分类枚举
enum HabitCategory {
  /// 🏠 生活习惯
  life,

  /// 💼 工作习惯
  work,

  /// 🏃 运动习惯
  sport,
}

/// HabitCategory 扩展方法
extension HabitCategoryX on HabitCategory {
  /// 从字符串创建 HabitCategory
  static HabitCategory fromString(String value) {
    return HabitCategory.values.firstWhere(
      (type) => type.name.toUpperCase() == value.toUpperCase(),
      orElse: () => HabitCategory.life,
    );
  }

  /// 获取显示名称
  String get displayName {
    switch (this) {
      case HabitCategory.life:
        return '生活';
      case HabitCategory.work:
        return '工作';
      case HabitCategory.sport:
        return '运动';
    }
  }

  /// 获取图标
  String get icon {
    switch (this) {
      case HabitCategory.life:
        return '🏠';
      case HabitCategory.work:
        return '💼';
      case HabitCategory.sport:
        return '🏃';
    }
  }

  /// 获取带图标的显示名称
  String get displayNameWithIcon {
    return '$icon $displayName';
  }

  /// 转换为数据库存储的字符串
  String toDbString() {
    return name.toUpperCase();
  }
}
