import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';

/// 习惯统计卡片组件
///
/// 展示 4 个关键统计指标：
/// - 连续天数
/// - 总执行次数
/// - 本周执行次数
/// - 完成率
class HabitStatsCard extends ConsumerWidget {
  final String habitId;

  const HabitStatsCard({
    super.key,
    required this.habitId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(habitStatsProvider(habitId));

    return statsAsync.when(
      data: (stats) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: CupertinoIcons.flame_fill,
                      iconColor: CupertinoColors.systemOrange,
                      label: '连续天数',
                      value: '${stats.currentStreak}',
                      unit: '天',
                      badge: stats.currentStreakBadge,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      icon: CupertinoIcons.checkmark_circle_fill,
                      iconColor: CupertinoColors.activeGreen,
                      label: '总执行次数',
                      value: '${stats.totalExecutions}',
                      unit: '次',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: CupertinoIcons.calendar,
                      iconColor: CupertinoColors.activeBlue,
                      label: '本周次数',
                      value: '${stats.thisWeekExecutions}',
                      unit: '次',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      icon: CupertinoIcons.chart_bar_circle_fill,
                      iconColor: CupertinoColors.systemPurple,
                      label: '完成率',
                      value: stats.completionRatePercentage,
                      unit: '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CupertinoColors.systemRed.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 32,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 8),
            Text(
              '统计加载失败',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String unit,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 4),
              if (badge != null)
                Text(
                  badge,
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
