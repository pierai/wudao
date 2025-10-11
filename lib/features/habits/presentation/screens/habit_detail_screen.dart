import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_category.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_calendar_heatmap.dart';
import '../widgets/habit_stats_card.dart';

/// 习惯详情页面
class HabitDetailScreen extends ConsumerWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除习惯'),
        content: const Text('确定要删除这个习惯吗？所有相关的打卡记录也会被删除。'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(habitRepositoryProvider);
      await repository.deleteHabit(habitId);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _handleEdit(BuildContext context) {
    AppRouter.toHabitEdit(context, habitId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(habitRepositoryProvider);

    return FutureBuilder<Habit?>(
      future: repository.getHabitById(habitId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text('加载中...')),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('错误')),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: 60,
                    color: CupertinoColors.systemRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.hasError ? '加载失败' : '习惯不存在',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          );
        }

        final habit = snapshot.data!;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(habit.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _handleEdit(context),
                  child: const Icon(CupertinoIcons.pencil),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _handleDelete(context, ref),
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.systemRed,
                  ),
                ),
              ],
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 习惯类型和分类标签
                Row(
                  children: [
                    // 类型标签（文字）
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeBadgeColor(habit),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        habit.typeDisplayText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getTypeTextColor(habit),
                        ),
                      ),
                    ),
                    // 分类标签
                    if (habit.category != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          habit.category!.displayName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // 统计卡片
                HabitStatsCard(habitId: habitId),
                const SizedBox(height: 24),

                // 习惯循环三要素
                _buildHabitLoopSection(habit),
                const SizedBox(height: 24),

                // 日历热力图
                HabitCalendarHeatmap(habitId: habitId),
                const SizedBox(height: 24),

                // 执行记录列表
                _buildRecordsSection(ref),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitLoopSection(Habit habit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '习惯循环',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // 暗示（Cue）
        _buildLoopCard(
          icon: CupertinoIcons.lightbulb,
          iconColor: CupertinoColors.systemYellow,
          title: '暗示（触发条件）',
          content: habit.cue ?? '',
        ),
        const SizedBox(height: 12),

        // 原惯常行为（仅习惯替代类型）
        if (habit.isReplacement && habit.oldRoutine != null) ...[
          _buildLoopCard(
            icon: CupertinoIcons.arrow_turn_up_left,
            iconColor: CupertinoColors.systemRed,
            title: '原惯常行为（要改变）',
            content: habit.oldRoutine!,
          ),
          const SizedBox(height: 12),
        ],

        // 惯常行为（Routine）
        _buildLoopCard(
          icon: CupertinoIcons.repeat,
          iconColor: CupertinoColors.activeBlue,
          title: habit.isReplacement ? '新惯常行为（替代）' : '惯常行为',
          content: habit.routine,
        ),
        const SizedBox(height: 12),

        // 奖赏（Reward）
        _buildLoopCard(
          icon: CupertinoIcons.star_fill,
          iconColor: CupertinoColors.systemOrange,
          title: '奖赏（获得的满足）',
          content: habit.reward ?? '',
        ),

        // 分类和备注
        if (habit.category != null || habit.notes != null) ...[
          const SizedBox(height: 16),
          if (habit.category != null)
            _buildInfoRow('分类', habit.category!.displayNameWithIcon),
          if (habit.notes != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('备注', habit.notes!),
          ],
        ],
      ],
    );
  }

  Widget _buildLoopCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label：',
          style: const TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildRecordsSection(WidgetRef ref) {
    final recordsAsync = ref.watch(habitRecordsProvider(habitId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '执行记录',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        recordsAsync.when(
          data: (records) {
            if (records.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.calendar_badge_plus,
                        size: 48,
                        color: CupertinoColors.systemGrey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '还没有执行记录',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: records.map((record) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.separator,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.clock,
                            size: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(record.executedAt),
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const Spacer(),
                          // 质量星级
                          Row(
                            children: List.generate(5, (index) {
                              final quality = record.quality ?? 3;
                              return Icon(
                                index < quality
                                    ? CupertinoIcons.star_fill
                                    : CupertinoIcons.star,
                                size: 16,
                                color: CupertinoColors.systemYellow,
                              );
                            }),
                          ),
                        ],
                      ),
                      if (record.notes != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          record.notes!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      if (record.isBackfilled) ...[
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              CupertinoIcons.arrow_counterclockwise,
                              size: 12,
                              color: CupertinoColors.systemGrey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '补打卡',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(
            child: Text(
              '加载失败: $error',
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final daysDiff = today.difference(recordDate).inDays;

    String dateStr;
    if (daysDiff == 0) {
      dateStr = '今天';
    } else if (daysDiff == 1) {
      dateStr = '昨天';
    } else if (daysDiff < 7) {
      dateStr = '$daysDiff 天前';
    } else {
      dateStr = '${dateTime.month}月${dateTime.day}日';
    }

    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return '$dateStr $timeStr';
  }

  // ========== 标签辅助方法 ==========

  /// 获取类型标签背景色
  Color _getTypeBadgeColor(Habit habit) {
    switch (habit.type) {
      case HabitType.positive:
        return CupertinoColors.activeGreen.withOpacity(0.15);
      case HabitType.core:
        return CupertinoColors.systemOrange.withOpacity(0.15);
      case HabitType.replacement:
        return CupertinoColors.activeBlue.withOpacity(0.15);
    }
  }

  /// 获取类型标签文字颜色
  Color _getTypeTextColor(Habit habit) {
    switch (habit.type) {
      case HabitType.positive:
        return CupertinoColors.activeGreen;
      case HabitType.core:
        return CupertinoColors.systemOrange;
      case HabitType.replacement:
        return CupertinoColors.activeBlue;
    }
  }
}
