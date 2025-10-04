import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_stats.freezed.dart';

/// 习惯统计数据实体
///
/// 包含习惯的各项统计指标
@freezed
sealed class HabitStats with _$HabitStats {
  const factory HabitStats({
    /// 当前连续天数
    required int currentStreak,

    /// 最佳连续记录
    required int bestStreak,

    /// 总执行次数
    required int totalExecutions,

    /// 本周执行次数
    required int thisWeekExecutions,

    /// 本月执行次数
    required int thisMonthExecutions,

    /// 完成率（0.0 - 1.0）
    required double completionRate,

    /// 平均质量评分（1-5）
    double? averageQuality,

    /// 最后打卡时间
    DateTime? lastExecutedAt,

    /// 第一次打卡时间
    DateTime? firstExecutedAt,
  }) = _HabitStats;

  const HabitStats._();

  /// 完成率百分比显示
  String get completionRatePercentage => '${(completionRate * 100).toStringAsFixed(1)}%';

  /// 当前连续天数徽章
  String get currentStreakBadge {
    if (currentStreak == 0) return '🔴';
    if (currentStreak < 7) return '🟡';
    if (currentStreak < 30) return '🟢';
    if (currentStreak < 100) return '🔵';
    return '🏆';
  }

  /// 统计摘要文本
  String get summary {
    final parts = <String>[];

    if (currentStreak > 0) {
      parts.add('连续 $currentStreak 天');
    }

    if (totalExecutions > 0) {
      parts.add('共 $totalExecutions 次');
    }

    if (completionRate > 0) {
      parts.add('完成率 $completionRatePercentage');
    }

    return parts.isEmpty ? '暂无数据' : parts.join(' · ');
  }

  /// 是否有数据
  bool get hasData => totalExecutions > 0;

  /// 平均质量评分显示
  String get averageQualityDisplay {
    if (averageQuality == null) return '暂无评分';
    return '⭐ ${averageQuality!.toStringAsFixed(1)}';
  }

  /// 习惯活跃程度等级
  String get activityLevel {
    if (currentStreak >= 30) return '非常活跃';
    if (currentStreak >= 7) return '活跃';
    if (currentStreak >= 3) return '一般';
    if (currentStreak > 0) return '刚起步';
    return '未开始';
  }

  /// 获取空统计（用于初始化）
  static HabitStats empty() => const HabitStats(
    currentStreak: 0,
    bestStreak: 0,
    totalExecutions: 0,
    thisWeekExecutions: 0,
    thisMonthExecutions: 0,
    completionRate: 0.0,
    averageQuality: null,
    lastExecutedAt: null,
    firstExecutedAt: null,
  );
}
