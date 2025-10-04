import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/daily_plan.dart';
import '../providers/habit_provider.dart';
import '../widgets/plan_generator_dialog.dart';

/// 次日计划页面
///
/// 基于《习惯的力量》理论，帮助用户提前规划次日的暗示任务
class DailyPlanScreen extends ConsumerStatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  ConsumerState<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends ConsumerState<DailyPlanScreen> {
  int _selectedSegment = 0; // 0: 今日计划, 1: 明日计划

  Future<void> _handleRefresh() async {
    ref.invalidate(todayPlansProvider);
  }

  void _showPlanGenerator() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const PlanGeneratorDialog(),
    );
  }

  Future<void> _handleCompletePlan(DailyPlan plan) async {
    if (plan.isCompleted) {
      // 已完成，取消完成
      final repository = ref.read(habitRepositoryProvider);
      await repository.uncompleteDailyPlan(plan.id);
      _handleRefresh();
    } else {
      // 未完成，询问是否打卡
      final shouldCheckIn = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('完成计划'),
          content: Text(
            '暗示"${plan.cueTask}"已完成\n是否执行惯常行为并打卡？',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('仅标记完成'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('完成并打卡'),
            ),
          ],
        ),
      );

      if (shouldCheckIn == true && mounted) {
        // TODO: 打开打卡对话框
        // 暂时先标记完成
        final repository = ref.read(habitRepositoryProvider);
        await repository.completeDailyPlan(plan.id, null);
        _handleRefresh();
      } else if (shouldCheckIn == false && mounted) {
        final repository = ref.read(habitRepositoryProvider);
        await repository.completeDailyPlan(plan.id, null);
        _handleRefresh();
      }
    }
  }

  Future<void> _handleDeletePlan(DailyPlan plan) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除计划'),
        content: Text('确定要删除计划"${plan.cueTask}"吗？'),
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

    if (confirmed == true && mounted) {
      final repository = ref.read(habitRepositoryProvider);
      await repository.deleteDailyPlan(plan.id);
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(todayPlansProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('次日计划'),
        transitionBetweenRoutes: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showPlanGenerator,
          child: const Icon(CupertinoIcons.add_circled),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 日期选择器
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSegmentedControl<int>(
                groupValue: _selectedSegment,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSegment = value;
                  });
                },
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('今日计划'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('明日计划'),
                  ),
                },
              ),
            ),

            // 计划列表
            Expanded(
              child: plansAsync.when(
                data: (plans) {
                  if (plans.isEmpty) {
                    return _buildEmptyState();
                  }

                  // 按优先级和状态排序
                  final sortedPlans = [...plans];
                  sortedPlans.sort((a, b) {
                    // 未完成的排前面
                    if (a.isCompleted != b.isCompleted) {
                      return a.isCompleted ? 1 : -1;
                    }
                    // 优先级高的排前面
                    return b.priority.compareTo(a.priority);
                  });

                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: _handleRefresh,
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final plan = sortedPlans[index];
                              return _buildPlanCard(plan);
                            },
                            childCount: sortedPlans.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CupertinoActivityIndicator(radius: 16),
                ),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(DailyPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(plan.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('删除计划'),
              content: Text('确定要删除"${plan.cueTask}"吗？'),
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
        },
        onDismissed: (direction) => _handleDeletePlan(plan),
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
          onTap: () => _handleCompletePlan(plan),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: CupertinoColors.separator,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                // 完成状态圆圈
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: plan.isCompleted
                        ? CupertinoColors.activeGreen
                        : CupertinoColors.systemGrey5,
                    border: Border.all(
                      color: plan.isCompleted
                          ? CupertinoColors.activeGreen
                          : CupertinoColors.systemGrey,
                      width: 2,
                    ),
                  ),
                  child: plan.isCompleted
                      ? const Icon(
                          CupertinoIcons.check_mark,
                          size: 14,
                          color: CupertinoColors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // 计划内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.cueTask,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: plan.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: plan.isCompleted
                              ? CupertinoColors.systemGrey
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.link,
                            size: 12,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(width: 4),
                          FutureBuilder<String>(
                            future: _getHabitName(plan.habitId),
                            builder: (context, snapshot) {
                              return Expanded(
                                child: Text(
                                  snapshot.data ?? '加载中...',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (plan.scheduledTime != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.clock,
                              size: 12,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(plan.scheduledTime!),
                              style: const TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 优先级标识
                if (plan.priority >= 8)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '高',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (plan.priority >= 5)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '中',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.calendar_today,
            size: 80,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '还没有计划',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击右上角 + 号从习惯生成计划',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: _showPlanGenerator,
            child: const Text('生成计划'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_triangle,
            size: 60,
            color: CupertinoColors.systemRed,
          ),
          const SizedBox(height: 16),
          const Text(
            '加载失败',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CupertinoButton(
            onPressed: _handleRefresh,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<String> _getHabitName(String habitId) async {
    final repository = ref.read(habitRepositoryProvider);
    final habit = await repository.getHabitById(habitId);
    return habit?.name ?? '未知习惯';
  }
}
