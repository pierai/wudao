import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';
import 'check_in_dialog.dart';

/// 习惯卡片组件
class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool showAssociatedHabits;

  const HabitCard({
    super.key,
    required this.habit,
    this.showAssociatedHabits = false,
  });

  Future<void> _handleCheckIn(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(habitRepositoryProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 检查今天是否已经打卡
    final hasRecord = await repository.hasTodayRecord(habit.id, today);

    if (hasRecord && context.mounted) {
      // 今日已打卡,显示提示对话框
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('今天已经打卡过了，不可重复打卡'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }

    if (!hasRecord && context.mounted) {
      // 显示打卡对话框
      final result = await showCheckInDialog(context, habit);

      // 如果打卡成功，刷新今日打卡状态和统计数据,并同步计划状态
      if (result == true && context.mounted) {
        // 获取今日打卡记录
        final todayRecord = await repository.getTodayRecord(habit.id, today);

        if (todayRecord != null) {
          // 同步计划状态(将关联的计划标记为 skipped 或 checkedIn)
          await repository.syncPlanStatusAfterCheckIn(
            habit.id,
            today,
            todayRecord.id,
          );
        }

        // 刷新相关 Provider
        ref.invalidate(hasTodayRecordProvider(habit.id));
        ref.invalidate(habitStatsProvider(habit.id));
        ref.invalidate(plansByDateProvider(today));
      }
    }
  }

  void _handleViewDetail(BuildContext context) {
    AppRouter.toHabitDetail(context, habit.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取习惯统计数据
    final statsAsync = ref.watch(habitStatsProvider(habit.id));
    // 检查今天是否已打卡
    final hasTodayRecordAsync = ref.watch(hasTodayRecordProvider(habit.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Dismissible(
        key: Key(habit.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('删除习惯'),
              content: Text('确定要删除"${habit.name}"吗？'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('删除'),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) async {
          final repository = ref.read(habitRepositoryProvider);
          await repository.deleteHabit(habit.id);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: CupertinoColors.systemRed,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Icon(
            CupertinoIcons.delete,
            color: CupertinoColors.white,
            size: 28,
          ),
        ),
        child: GestureDetector(
          onTap: () => _handleViewDetail(context),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: CupertinoColors.separator, width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：习惯名称 + 快速打卡按钮
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 习惯类型标签和核心习惯徽章
                          Row(
                            children: [
                              // 习惯类型标签
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: habit.isPositive
                                      ? CupertinoColors.activeGreen.withOpacity(
                                          0.1,
                                        )
                                      : CupertinoColors.activeBlue.withOpacity(
                                          0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  habit.typeDisplayText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: habit.isPositive
                                        ? CupertinoColors.activeGreen
                                        : CupertinoColors.activeBlue,
                                  ),
                                ),
                              ),
                              // 核心习惯徽章
                              if (habit.isCore) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemOrange
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '💎',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '核心习惯',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.systemOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 快速打卡按钮
                    GestureDetector(
                      onTap: () {}, // 阻止事件冒泡到卡片
                      child: hasTodayRecordAsync.when(
                        data: (hasTodayRecord) {
                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: hasTodayRecord
                                ? null
                                : () => _handleCheckIn(context, ref),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: hasTodayRecord
                                    ? CupertinoColors.activeGreen
                                    : CupertinoColors.systemGrey5,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                hasTodayRecord
                                    ? CupertinoIcons.check_mark
                                    : CupertinoIcons.circle,
                                color: hasTodayRecord
                                    ? CupertinoColors.white
                                    : CupertinoColors.systemGrey,
                                size: 24,
                              ),
                            ),
                          );
                        },
                        loading: () => const CupertinoActivityIndicator(),
                        error: (_, __) => const Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 暗示预览（如果有）
                if (habit.cue != null && habit.cue!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.lightbulb,
                        size: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          habit.cue!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                // 统计信息
                statsAsync.when(
                  data: (stats) {
                    return Row(
                      children: [
                        // 连续天数
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                stats.currentStreakBadge,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${stats.currentStreak} 天',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 完成率
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '完成率 ${stats.completionRatePercentage}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CupertinoActivityIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // 核心习惯展开功能
                if (showAssociatedHabits)
                  _buildAssociatedHabitsSection(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建关联习惯展开区域
  Widget _buildAssociatedHabitsSection(BuildContext context, WidgetRef ref) {
    // 获取展开状态
    final expandedMap = ref.watch(keystoneExpandedProvider);
    final isExpanded = expandedMap[habit.id] ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        // 展开/收起按钮
        GestureDetector(
          onTap: () {
            final currentMap = ref.read(keystoneExpandedProvider);
            ref.read(keystoneExpandedProvider.notifier).state = {
              ...currentMap,
              habit.id: !isExpanded,
            };
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 16,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  isExpanded ? '收起关联习惯' : '查看关联习惯',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 关联习惯列表
        if (isExpanded) _buildAssociatedHabitsList(context, ref),
      ],
    );
  }

  /// 构建关联习惯列表
  Widget _buildAssociatedHabitsList(BuildContext context, WidgetRef ref) {
    final associatedHabitsAsync = ref.watch(associatedHabitsProvider(habit.id));

    return associatedHabitsAsync.when(
      data: (associatedHabits) {
        if (associatedHabits.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              '暂无关联习惯',
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ...associatedHabits.map((associatedHabit) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // 关联习惯图标
                    const Icon(
                      CupertinoIcons.link,
                      size: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(width: 8),
                    // 关联习惯名称
                    Expanded(
                      child: Text(
                        associatedHabit.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    // 移除关联按钮
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _handleRemoveAssociation(
                        context,
                        ref,
                        associatedHabit,
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 20,
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: CupertinoActivityIndicator(),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          '加载失败: $error',
          style: const TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
    );
  }

  /// 处理移除关联
  Future<void> _handleRemoveAssociation(
    BuildContext context,
    WidgetRef ref,
    Habit associatedHabit,
  ) async {
    // 显示确认对话框
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('移除关联'),
        content: Text('确定要移除"${associatedHabit.name}"的关联吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('移除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(habitRepositoryProvider);
        await repository.removeHabitAssociation(
          keystoneHabitId: habit.id,
          associatedHabitId: associatedHabit.id,
        );

        // 刷新关联习惯列表
        ref.invalidate(associatedHabitsProvider(habit.id));

        if (context.mounted) {
          // 显示成功提示
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('成功'),
              content: const Text('已移除关联'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          // 显示错误提示
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('失败'),
              content: Text('移除关联失败: $e'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      }
    }
  }
}
