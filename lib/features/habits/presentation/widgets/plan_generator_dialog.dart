import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/plan_completion_status.dart';
import '../providers/habit_provider.dart';

/// 计划生成器对话框
///
/// 从习惯列表选择，批量生成次日计划
class PlanGeneratorDialog extends ConsumerStatefulWidget {
  const PlanGeneratorDialog({super.key});

  @override
  ConsumerState<PlanGeneratorDialog> createState() =>
      _PlanGeneratorDialogState();
}

class _PlanGeneratorDialogState extends ConsumerState<PlanGeneratorDialog> {
  final Set<String> _selectedHabitIds = {};
  final Map<String, DateTime?> _suggestedTimes = {};
  final Map<String, int> _priorities = {};
  bool _isSaving = false;

  // 新增：计划日期，默认为明天
  late DateTime _planDate;

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _planDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('生成习惯计划'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _selectedHabitIds.isEmpty || _isSaving
              ? null
              : _handleGenerate,
          child: _isSaving
              ? const CupertinoActivityIndicator()
              : const Text('生成'),
        ),
      ),
      child: SafeArea(
        child: habitsAsync.when(
          data: (habits) {
            if (habits.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.square_list,
                      size: 60,
                      color: CupertinoColors.systemGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '还没有习惯',
                      style: TextStyle(
                        fontSize: 18,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '请先创建习惯',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 日期选择器
                _buildDateSelector(),
                const SizedBox(height: 24),

                const Text(
                  '选择要规划的习惯：',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...habits.map((habit) => _buildHabitItem(habit)),
              ],
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
      ),
    );
  }

  Widget _buildHabitItem(Habit habit) {
    final isSelected = _selectedHabitIds.contains(habit.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedHabitIds.remove(habit.id);
            _suggestedTimes.remove(habit.id);
            _priorities.remove(habit.id);
          } else {
            _selectedHabitIds.add(habit.id);
            _priorities[habit.id] = habit.isCore ? 8 : 5; // 核心习惯默认高优先级
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue.withOpacity(0.1)
              : CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.activeBlue
                : CupertinoColors.separator,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 选择圆圈
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey5,
                    border: Border.all(
                      color: isSelected
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.systemGrey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          CupertinoIcons.check_mark,
                          size: 14,
                          color: CupertinoColors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // 习惯名称和徽章
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (habit.isCore) ...[
                        const SizedBox(width: 8),
                        const Text('💎', style: TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // 暗示预览
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 36), // 对齐复选框
                const Icon(
                  CupertinoIcons.lightbulb,
                  size: 14,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    habit.cue ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // 选中后显示时间和优先级设置
            if (isSelected) ...[
              const SizedBox(height: 12),
              Container(height: 0.5, color: CupertinoColors.separator),
              const SizedBox(height: 12),

              // 建议时间
              Row(
                children: [
                  const SizedBox(width: 36),
                  const Icon(
                    CupertinoIcons.clock,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '建议时间：',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _pickTime(habit.id),
                    child: Text(
                      _suggestedTimes[habit.id] != null
                          ? _formatTime(_suggestedTimes[habit.id]!)
                          : '未设置',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 优先级
              Row(
                children: [
                  const SizedBox(width: 36),
                  const Icon(
                    CupertinoIcons.flag,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '优先级：',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  CupertinoSegmentedControl<int>(
                    groupValue: _priorities[habit.id] ?? 5,
                    onValueChanged: (value) {
                      setState(() {
                        _priorities[habit.id] = value;
                      });
                    },
                    children: const {
                      3: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text('低', style: TextStyle(fontSize: 12)),
                      ),
                      5: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text('中', style: TextStyle(fontSize: 12)),
                      ),
                      8: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text('高', style: TextStyle(fontSize: 12)),
                      ),
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建日期选择器
  Widget _buildDateSelector() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = _planDate == today;
    final isTomorrow = _planDate == today.add(const Duration(days: 1));

    String dateLabel;
    if (isToday) {
      dateLabel = '今天 ${_formatDate(_planDate)}';
    } else if (isTomorrow) {
      dateLabel = '明天 ${_formatDate(_planDate)}';
    } else {
      dateLabel = _formatDate(_planDate);
    }

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.calendar,
            size: 20,
            color: CupertinoColors.systemBlue,
          ),
          const SizedBox(width: 12),
          const Text(
            '计划日期：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _pickPlanDate,
            child: Row(
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(CupertinoIcons.chevron_right, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 选择计划日期
  void _pickPlanDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 280,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // 顶部操作栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // 日期选择器
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _planDate,
                  minimumDate: DateTime.now(), // 最早只能选今天
                  maximumDate: DateTime.now().add(
                    const Duration(days: 365),
                  ), // 最多一年后
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _planDate = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickTime(String habitId) {
    DateTime initialTime = _suggestedTimes[habitId] ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 280,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // 顶部操作栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // 时间选择器
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      _suggestedTimes[habitId] = newTime;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGenerate() async {
    if (_selectedHabitIds.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(habitRepositoryProvider);

      // 获取选中的习惯详情
      final plans = <DailyPlan>[];

      for (final habitId in _selectedHabitIds) {
        final habit = await repository.getHabitById(habitId);
        if (habit == null) continue;

        final plan = DailyPlan(
          id: 'plan_${DateTime.now().millisecondsSinceEpoch}_$habitId',
          habitId: habitId,
          planDate: _planDate, // 使用用户选择的日期
          cueTask: habit.cue ?? '', // 将暗示作为任务
          scheduledTime: _suggestedTimes[habitId],
          priority: _priorities[habitId] ?? 5,
          status: PlanCompletionStatus.pending, // 初始状态为待执行
          cueCompletedAt: null,
          checkedInAt: null,
          recordId: null,
          createdAt: DateTime.now(),
          updatedAt: null,
          // 提醒功能：当设置了时间时自动启用提醒
          reminderEnabled: _suggestedTimes[habitId] != null,
          reminderMinutesBefore: 0, // 默认准时提醒
        );

        plans.add(plan);
      }

      await repository.createDailyPlans(plans);

      if (mounted) {
        // 关闭对话框并返回成功标识
        Navigator.of(context).pop(true);
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('成功'),
            content: Text('已为明日生成 ${plans.length} 个计划'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('生成失败'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }
}
