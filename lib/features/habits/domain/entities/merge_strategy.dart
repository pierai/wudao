/// 数据合并策略
enum MergeStrategy {
  /// 完全覆盖（清空当前数据后导入）
  replaceAll,

  /// 保留新数据（导入文件优先）
  keepNew,

  /// 保留旧数据（当前设备优先）
  keepOld,

  /// 智能合并（按更新时间）
  smartMerge,

  /// 手动选择（逐项确认）
  manual,
}

extension MergeStrategyX on MergeStrategy {
  /// 显示名称
  String get displayName {
    switch (this) {
      case MergeStrategy.replaceAll:
        return '完全覆盖';
      case MergeStrategy.keepNew:
        return '保留新数据';
      case MergeStrategy.keepOld:
        return '保留旧数据';
      case MergeStrategy.smartMerge:
        return '智能合并';
      case MergeStrategy.manual:
        return '手动选择';
    }
  }

  /// 描述
  String get description {
    switch (this) {
      case MergeStrategy.replaceAll:
        return '⚠️ 删除当前所有数据，完全使用导入文件的数据（不可恢复）';
      case MergeStrategy.keepNew:
        return '导入文件的数据将覆盖当前设备的数据';
      case MergeStrategy.keepOld:
        return '保留当前设备的数据，跳过导入文件中的冲突项';
      case MergeStrategy.smartMerge:
        return '根据更新时间自动选择最新的数据';
      case MergeStrategy.manual:
        return '逐项对比冲突数据，手动选择保留哪个';
    }
  }

  /// 是否为危险操作
  bool get isDangerous => this == MergeStrategy.replaceAll;

  /// 图标
  String get icon {
    switch (this) {
      case MergeStrategy.replaceAll:
        return '🗑️';
      case MergeStrategy.keepNew:
        return '📥';
      case MergeStrategy.keepOld:
        return '💾';
      case MergeStrategy.smartMerge:
        return '🧠';
      case MergeStrategy.manual:
        return '👆';
    }
  }
}
