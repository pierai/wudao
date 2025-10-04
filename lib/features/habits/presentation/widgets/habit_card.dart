import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';
import '../screens/habit_form_screen.dart';
import 'check_in_dialog.dart';

/// 习惯卡片组件
class HabitCard extends ConsumerWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  Future<void> _handleCheckIn(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(habitRepositoryProvider);
    final now = DateTime.now();

    // 检查今天是否已经打卡
    final hasRecord = await repository.hasRecordOnDate(habit.id, now);

    if (!hasRecord && context.mounted) {
      // 显示打卡对话框
      await showCheckInDialog(context, habit);
    }
  }

  void _handleEdit(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => HabitFormScreen(habitId: habit.id)));
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
          onTap: () => _handleEdit(context),
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
                          Text(habit.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          // 习惯类型标签
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: habit.isPositive
                                  ? CupertinoColors.activeGreen.withOpacity(0.1)
                                  : CupertinoColors.activeBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              habit.typeDisplayText,
                              style: TextStyle(
                                fontSize: 12,
                                color: habit.isPositive ? CupertinoColors.activeGreen : CupertinoColors.activeBlue,
                              ),
                            ),
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
                            onPressed: hasTodayRecord ? null : () => _handleCheckIn(context, ref),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: hasTodayRecord ? CupertinoColors.activeGreen : CupertinoColors.systemGrey5,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                hasTodayRecord ? CupertinoIcons.check_mark : CupertinoIcons.circle,
                                color: hasTodayRecord ? CupertinoColors.white : CupertinoColors.systemGrey,
                                size: 24,
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
                const SizedBox(height: 12),
                // 暗示预览
                Row(
                  children: [
                    const Icon(CupertinoIcons.lightbulb, size: 16, color: CupertinoColors.systemGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        habit.cue,
                        style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 统计信息
                statsAsync.when(
                  data: (stats) {
                    return Row(
                      children: [
                        // 连续天数
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text(stats.currentStreakBadge, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text('${stats.currentStreak} 天', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 完成率
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '完成率 ${stats.completionRatePercentage}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CupertinoActivityIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
