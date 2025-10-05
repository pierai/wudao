import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit.dart';
import 'habit_record.dart';
import 'daily_plan.dart';
import 'habit_frontmatter.dart';

part 'conflict_info.freezed.dart';

/// 冲突类型
enum ConflictType {
  /// 习惯冲突
  habit,

  /// 打卡记录冲突
  record,

  /// 计划冲突
  plan,

  /// Frontmatter 冲突
  frontmatter,
}

/// 冲突信息
@freezed
sealed class ConflictInfo with _$ConflictInfo {
  const factory ConflictInfo({
    /// 冲突类型
    required ConflictType type,

    /// 冲突 ID
    required String conflictId,

    /// 当前设备数据（JSON）
    required Map<String, dynamic> currentData,

    /// 导入文件数据（JSON）
    required Map<String, dynamic> importData,

    /// 冲突原因描述
    required String reason,

    /// 推荐的合并方式（基于更新时间）
    String? recommendedAction,
  }) = _ConflictInfo;

  const ConflictInfo._();

  /// 创建习惯冲突
  factory ConflictInfo.habit({
    required Habit current,
    required Habit imported,
  }) {
    final currentNewer = current.updatedAt.isAfter(imported.updatedAt);
    return ConflictInfo(
      type: ConflictType.habit,
      conflictId: current.id,
      currentData: current.toJson(),
      importData: imported.toJson(),
      reason: '习惯「${current.name}」在两个设备都存在',
      recommendedAction: currentNewer
          ? '当前设备更新（${current.updatedAt}），推荐保留旧数据'
          : '导入文件更新（${imported.updatedAt}），推荐保留新数据',
    );
  }

  /// 创建打卡记录冲突
  factory ConflictInfo.record({
    required HabitRecord current,
    required HabitRecord imported,
  }) {
    final currentBetterQuality =
        (current.quality ?? 0) >= (imported.quality ?? 0);
    return ConflictInfo(
      type: ConflictType.record,
      conflictId: current.id,
      currentData: current.toJson(),
      importData: imported.toJson(),
      reason: '同一天（${current.executedAt.toString().substring(0, 10)}）存在多条打卡记录',
      recommendedAction: currentBetterQuality
          ? '当前记录质量更高（${current.quality ?? 0} 星），推荐保留旧数据'
          : '导入记录质量更高（${imported.quality ?? 0} 星），推荐保留新数据',
    );
  }

  /// 创建计划冲突
  factory ConflictInfo.plan({
    required DailyPlan current,
    required DailyPlan imported,
  }) {
    return ConflictInfo(
      type: ConflictType.plan,
      conflictId: current.id,
      currentData: current.toJson(),
      importData: imported.toJson(),
      reason: '计划「${current.cueTask}」在两个设备都存在',
      recommendedAction: '推荐合并两个计划（去重）',
    );
  }

  /// 创建 Frontmatter 冲突
  factory ConflictInfo.frontmatter({
    required HabitFrontmatter current,
    required HabitFrontmatter imported,
  }) {
    final currentNewer = current.updatedAt.isAfter(imported.updatedAt);
    return ConflictInfo(
      type: ConflictType.frontmatter,
      conflictId: current.id,
      currentData: current.toJson(),
      importData: imported.toJson(),
      reason: 'Frontmatter「${current.title}」在两个设备都存在',
      recommendedAction: currentNewer
          ? '当前设备更新（${current.updatedAt}），推荐保留旧数据'
          : '导入文件更新（${imported.updatedAt}），推荐保留新数据',
    );
  }

  /// 获取冲突项的显示名称
  String get displayName {
    switch (type) {
      case ConflictType.habit:
        return currentData['name'] as String? ?? '未命名习惯';
      case ConflictType.record:
        return '打卡记录';
      case ConflictType.plan:
        return currentData['cue_task'] as String? ?? '未命名计划';
      case ConflictType.frontmatter:
        return currentData['title'] as String? ?? '未命名感悟';
    }
  }
}
