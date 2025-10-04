import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/habit.dart';
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

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('从习惯生成计划'),
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
                const Text(
                  '选择要规划的习惯：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...habits.map((habit) => _buildHabitItem(habit)),
              ],
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
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
            _priorities[habit.id] = habit.isKeystone ? 8 : 5; // 核心习惯默认高优先级
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
                      if (habit.isKeystone) ...[
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
                    habit.cue,
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
              Container(
                height: 0.5,
                color: CupertinoColors.separator,
              ),
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text('低', style: TextStyle(fontSize: 12)),
                      ),
                      5: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text('中', style: TextStyle(fontSize: 12)),
                      ),
                      8: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

  void _pickTime(String habitId) {
    DateTime initialTime = _suggestedTimes[habitId] ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            ),
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
    );
  }

  Future<void> _handleGenerate() async {
    if (_selectedHabitIds.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(habitRepositoryProvider);
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

      // 获取选中的习惯详情
      final plans = <DailyPlan>[];

      for (final habitId in _selectedHabitIds) {
        final habit = await repository.getHabitById(habitId);
        if (habit == null) continue;

        final plan = DailyPlan(
          id: 'plan_${DateTime.now().millisecondsSinceEpoch}_$habitId',
          habitId: habitId,
          planDate: tomorrowDate,
          cueTask: habit.cue, // 将暗示作为任务
          scheduledTime: _suggestedTimes[habitId],
          priority: _priorities[habitId] ?? 5,
          isCompleted: false,
          completedAt: null,
          recordId: null,
          createdAt: DateTime.now(),
        );

        plans.add(plan);
      }

      await repository.createDailyPlans(plans);

      if (mounted) {
        Navigator.of(context).pop();
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
}
