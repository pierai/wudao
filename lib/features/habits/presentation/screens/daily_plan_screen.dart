import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_segmented_control.dart';
import '../../domain/entities/daily_plan.dart';
import '../providers/habit_provider.dart';
import '../widgets/check_in_dialog.dart';
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
    // 根据选中的日期刷新对应的计划列表
    // 注意：必须去掉时间部分，保持与build方法中的日期格式一致
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = _selectedSegment == 0
        ? today
        : today.add(const Duration(days: 1));
    ref.invalidate(plansByDateProvider(date));
  }

  void _showPlanGenerator() async {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => const PlanGeneratorDialog(),
    );

    // 如果成功生成计划，自动切换到明日计划标签
    if (result == true && mounted) {
      setState(() {
        _selectedSegment = 1;
      });
    }
  }

  /// 处理点击计划卡片(标记/取消暗示完成)
  Future<void> _handleCompletePlan(DailyPlan plan) async {
    // 明日计划不可操作
    if (!plan.isActionable) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('明天才能执行此计划'),
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

    final repository = ref.read(habitRepositoryProvider);

    // 根据当前状态决定行为
    if (plan.isPending) {
      // pending → cueCompleted (标记暗示完成)
      await repository.markCueCompleted(plan.id);
      _handleRefresh();
    } else if (plan.isCueCompleted) {
      // cueCompleted → pending (取消暗示完成)
      await repository.markCueIncomplete(plan.id);
      _handleRefresh();
    } else if (plan.isCheckedIn) {
      // checkedIn → cueCompleted (取消打卡)
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('取消打卡'),
          content: const Text('确定要取消打卡吗？打卡记录将被删除。'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定'),
            ),
          ],
        ),
      );

      if (confirmed == true && plan.recordId != null && mounted) {
        await repository.cancelCheckIn(plan.recordId!);
        _handleRefresh();
      }
    }
    // skipped 状态不可操作
  }

  /// 处理打卡按钮点击(仅在 cueCompleted 状态显示)
  Future<void> _handleCheckIn(DailyPlan plan) async {
    final repository = ref.read(habitRepositoryProvider);

    // 获取习惯信息
    final habit = await repository.getHabitById(plan.habitId);
    if (habit == null || !mounted) return;

    // 显示打卡对话框
    final recordId = await showPlanCheckInDialog(context, habit, plan);

    // 如果打卡成功,标记计划为 checkedIn
    if (recordId != null && mounted) {
      await repository.markPlanCheckedIn(plan.id, recordId);
      _handleRefresh();
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
    // 根据选中的日期获取对应的计划列表
    // 注意：必须去掉时间部分，否则每次build都会创建新的DateTime对象
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = _selectedSegment == 0
        ? today
        : today.add(const Duration(days: 1));

    final plansAsync = ref.watch(plansByDateProvider(date));

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
              child: CustomSegmentedControl<int>(
                groupValue: _selectedSegment,
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSegment = value;
                    });
                  }
                },
                borderRadius: 12, // 增大圆角
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
                    // 已完成的(checkedIn/skipped)排后面,pending/cueCompleted 排前面
                    final aCompleted = a.isCheckedIn || a.isSkipped;
                    final bCompleted = b.isCheckedIn || b.isSkipped;
                    if (aCompleted != bCompleted) {
                      return aCompleted ? 1 : -1;
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
                // 状态指示器
                _buildStatusIndicator(plan),
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
                          decoration: plan.isSkipped
                              ? TextDecoration.lineThrough
                              : null,
                          color: plan.isSkipped || !plan.isActionable
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

                // 操作按钮/徽章
                _buildActionButton(plan),

                const SizedBox(width: 8),

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

  /// 根据计划状态构建状态指示器
  Widget _buildStatusIndicator(DailyPlan plan) {
    if (plan.isSkipped) {
      return const Icon(
        CupertinoIcons.exclamationmark_triangle,
        size: 24,
        color: CupertinoColors.systemOrange,
      );
    }

    final bool isCompleted = plan.isCueCompleted || plan.isCheckedIn;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? CupertinoColors.activeGreen
            : CupertinoColors.systemGrey5,
        border: Border.all(
          color: isCompleted
              ? CupertinoColors.activeGreen
              : CupertinoColors.systemGrey,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(
              CupertinoIcons.check_mark,
              size: 14,
              color: CupertinoColors.white,
            )
          : null,
    );
  }

  /// 根据计划状态构建操作按钮/徽章
  Widget _buildActionButton(DailyPlan plan) {
    if (plan.isCueCompleted && plan.isActionable) {
      // 暗示已完成,显示"打卡"按钮
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minSize: 0,
        color: CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(6),
        onPressed: () => _handleCheckIn(plan),
        child: const Text(
          '打卡',
          style: TextStyle(fontSize: 14, color: CupertinoColors.white),
        ),
      );
    } else if (plan.isCheckedIn) {
      // 已打卡,显示"已打卡"徽章
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: CupertinoColors.activeGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '已打卡',
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.activeGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (plan.isSkipped) {
      // 已跳过,显示"已跳过"徽章
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: CupertinoColors.systemOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '已跳过',
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
