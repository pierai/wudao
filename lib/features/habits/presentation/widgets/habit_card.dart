import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_category.dart';
import '../providers/habit_provider.dart';
import 'check_in_dialog.dart';

/// 习惯卡片组件（支持响应式布局）
class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool showAssociatedHabits;

  const HabitCard({super.key, required this.habit, this.showAssociatedHabits = false});

  /// 判断是否为紧凑模式（iPhone）
  bool _isCompactMode(BuildContext context) {
    // iOS且屏幕宽度小于等于iPhone Pro Max宽度
    return Platform.isIOS && MediaQuery.of(context).size.width <= 428;
  }

  // ========== 响应式布局参数 ==========

  /// 卡片外层横向 padding
  double _outerHorizontalPadding(BuildContext context) {
    return _isCompactMode(context) ? 12.0 : 16.0;
  }

  /// 卡片外层纵向 padding
  double _outerVerticalPadding(BuildContext context) {
    return _isCompactMode(context) ? 6.0 : 8.0;
  }

  /// 卡片内层 padding
  double _innerPadding(BuildContext context) {
    return _isCompactMode(context) ? 12.0 : 16.0;
  }

  /// 标题字体大小
  double _titleFontSize(BuildContext context) {
    return _isCompactMode(context) ? 16.0 : 18.0;
  }

  /// 类型标签字体大小
  double _typeBadgeFontSize(BuildContext context) {
    return _isCompactMode(context) ? 11.0 : 12.0;
  }

  /// 类型标签 padding
  EdgeInsets _typeBadgePadding(BuildContext context) {
    return _isCompactMode(context)
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
  }

  /// 暗示区块字体大小
  double _cueFontSize(BuildContext context) {
    return _isCompactMode(context) ? 13.0 : 14.0;
  }

  /// 暗示区块图标大小
  double _cueIconSize(BuildContext context) {
    return _isCompactMode(context) ? 14.0 : 16.0;
  }

  /// 区块间隔
  double _sectionSpacing(BuildContext context) {
    return _isCompactMode(context) ? 8.0 : 12.0;
  }

  /// 统计信息字体大小
  double _statsFontSize(BuildContext context) {
    return _isCompactMode(context) ? 13.0 : 14.0;
  }

  /// 统计信息 padding
  EdgeInsets _statsPadding(BuildContext context) {
    return _isCompactMode(context)
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  }

  /// 快速打卡按钮尺寸
  double _checkInButtonSize(BuildContext context) {
    return _isCompactMode(context) ? 40.0 : 44.0;
  }

  /// 快速打卡按钮图标尺寸
  double _checkInButtonIconSize(BuildContext context) {
    return _isCompactMode(context) ? 20.0 : 24.0;
  }

  /// 是否显示暗示预览（iPhone 上可隐藏以节省空间）
  bool _showCuePreview(BuildContext context) {
    // iPhone 上如果暗示内容较长，可以考虑隐藏
    // 这里先保留显示，用户可以根据需要调整
    return true; // _isCompactMode(context) ? false : true;
  }

  /// 标签之间的间隔
  double _badgeSpacing(BuildContext context) {
    return _isCompactMode(context) ? 4.0 : 6.0;
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
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(context).pop(), child: const Text('确定'))],
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
          await repository.syncPlanStatusAfterCheckIn(habit.id, today, todayRecord.id);
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
      padding: EdgeInsets.symmetric(horizontal: _outerHorizontalPadding(context), vertical: _outerVerticalPadding(context)),
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
                CupertinoDialogAction(child: const Text('取消'), onPressed: () => Navigator.of(context).pop(false)),
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
          decoration: BoxDecoration(color: CupertinoColors.systemRed, borderRadius: BorderRadius.circular(12.0)),
          child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white, size: 28),
        ),
        child: GestureDetector(
          onTap: () => _handleViewDetail(context),
          child: Container(
            padding: EdgeInsets.all(_innerPadding(context)),
            decoration: BoxDecoration(
              // 核心习惯使用淡橙色背景
              color: habit.isCore ? CupertinoColors.systemOrange.withOpacity(0.05) : CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                // 核心习惯使用橙色边框
                color: habit.isCore ? CupertinoColors.systemOrange.withOpacity(0.3) : CupertinoColors.separator,
                width: habit.isCore ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：习惯名称 + 标签 + 快速打卡按钮
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // 习惯名称
                          Flexible(
                            child: Text(
                              habit.name,
                              style: TextStyle(fontSize: _titleFontSize(context), fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 习惯类型标签（核心习惯不显示，用背景色表示）
                          if (!habit.isCore) ...[
                            SizedBox(width: _badgeSpacing(context)),
                            Container(
                              padding: _typeBadgePadding(context),
                              decoration: BoxDecoration(color: _getTypeBadgeColor(habit), borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                habit.typeDisplayText,
                                style: TextStyle(
                                  fontSize: _typeBadgeFontSize(context),
                                  fontWeight: FontWeight.w600,
                                  color: _getTypeTextColor(habit),
                                ),
                              ),
                            ),
                          ],
                          // 分类标签
                          if (habit.category != null) ...[
                            SizedBox(width: _badgeSpacing(context)),
                            Container(
                              padding: _typeBadgePadding(context),
                              decoration: BoxDecoration(color: CupertinoColors.systemGrey5, borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                habit.category!.displayName,
                                style: TextStyle(
                                  fontSize: _typeBadgeFontSize(context),
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                          ],
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
                            onPressed: hasTodayRecord ? null : () => _handleCheckIn(context, ref),
                            child: Container(
                              width: _checkInButtonSize(context),
                              height: _checkInButtonSize(context),
                              decoration: BoxDecoration(
                                color: hasTodayRecord ? CupertinoColors.activeGreen : CupertinoColors.systemGrey5,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                hasTodayRecord ? CupertinoIcons.check_mark : CupertinoIcons.circle,
                                color: hasTodayRecord ? CupertinoColors.white : CupertinoColors.systemGrey,
                                size: _checkInButtonIconSize(context),
                              ),
                            ),
                          );
                        },
                        loading: () => const CupertinoActivityIndicator(),
                        error: (_, __) => const Icon(CupertinoIcons.exclamationmark_circle, color: CupertinoColors.systemRed),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _sectionSpacing(context)),
                // 暗示预览（如果有）
                if (_showCuePreview(context) && habit.cue != null && habit.cue!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(CupertinoIcons.lightbulb, size: _cueIconSize(context), color: CupertinoColors.systemGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          habit.cue!,
                          style: TextStyle(fontSize: _cueFontSize(context), color: CupertinoColors.systemGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _sectionSpacing(context)),
                ],
                // 统计信息 + 展开按钮（同一行）
                statsAsync.when(
                  data: (stats) {
                    return Row(
                      children: [
                        // 连续天数
                        Container(
                          padding: _statsPadding(context),
                          decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text(stats.currentStreakBadge, style: TextStyle(fontSize: _statsFontSize(context))),
                              const SizedBox(width: 4),
                              Text(
                                '${stats.currentStreak} 天',
                                style: TextStyle(fontSize: _statsFontSize(context), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 完成率
                        Container(
                          padding: _statsPadding(context),
                          decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '完成率 ${stats.completionRatePercentage}',
                            style: TextStyle(fontSize: _statsFontSize(context), fontWeight: FontWeight.w600),
                          ),
                        ),
                        // 展开按钮（仅核心习惯显示）
                        if (showAssociatedHabits) ...[const Spacer(), _buildExpandButton(context, ref)],
                      ],
                    );
                  },
                  loading: () => const CupertinoActivityIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // 关联习惯列表（展开时显示）
                if (showAssociatedHabits) _buildExpandedAssociatedHabits(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建展开按钮（紧凑版，放在统计信息右侧）
  Widget _buildExpandButton(BuildContext context, WidgetRef ref) {
    final expandedMap = ref.watch(keystoneExpandedProvider);
    final isExpanded = expandedMap[habit.id] ?? false;

    return GestureDetector(
      onTap: () {
        final currentMap = ref.read(keystoneExpandedProvider);
        ref.read(keystoneExpandedProvider.notifier).state = {...currentMap, habit.id: !isExpanded};
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: _isCompactMode(context) ? 8 : 10, vertical: _isCompactMode(context) ? 4 : 5),
        decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isExpanded ? '收起' : '关联习惯',
              style: TextStyle(
                fontSize: _isCompactMode(context) ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
              size: _isCompactMode(context) ? 12 : 14,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建展开后的关联习惯列表
  Widget _buildExpandedAssociatedHabits(BuildContext context, WidgetRef ref) {
    final expandedMap = ref.watch(keystoneExpandedProvider);
    final isExpanded = expandedMap[habit.id] ?? false;

    if (!isExpanded) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: _sectionSpacing(context)),
        _buildAssociatedHabitsList(context, ref),
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
            child: const Text('暂无关联习惯', style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
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
                decoration: BoxDecoration(color: CupertinoColors.systemGrey6.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    // 关联习惯图标
                    const Icon(CupertinoIcons.link, size: 16, color: CupertinoColors.systemGrey),
                    const SizedBox(width: 8),
                    // 关联习惯名称
                    Expanded(child: Text(associatedHabit.name, style: const TextStyle(fontSize: 14))),
                    // 移除关联按钮
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _handleRemoveAssociation(context, ref, associatedHabit),
                      child: const Icon(CupertinoIcons.xmark_circle_fill, size: 20, color: CupertinoColors.systemGrey2),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: CupertinoActivityIndicator()),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text('加载失败: $error', style: const TextStyle(fontSize: 14, color: CupertinoColors.systemRed)),
      ),
    );
  }

  /// 处理移除关联
  Future<void> _handleRemoveAssociation(BuildContext context, WidgetRef ref, Habit associatedHabit) async {
    // 显示确认对话框
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('移除关联'),
        content: Text('确定要移除"${associatedHabit.name}"的关联吗？'),
        actions: [
          CupertinoDialogAction(child: const Text('取消'), onPressed: () => Navigator.of(context).pop(false)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(context).pop(true), child: const Text('移除')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(habitRepositoryProvider);
        await repository.removeHabitAssociation(keystoneHabitId: habit.id, associatedHabitId: associatedHabit.id);

        // 刷新关联习惯列表
        ref.invalidate(associatedHabitsProvider(habit.id));

        if (context.mounted) {
          // 显示成功提示
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('成功'),
              content: const Text('已移除关联'),
              actions: [CupertinoDialogAction(child: const Text('确定'), onPressed: () => Navigator.of(context).pop())],
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
              actions: [CupertinoDialogAction(child: const Text('确定'), onPressed: () => Navigator.of(context).pop())],
            ),
          );
        }
      }
    }
  }
}
