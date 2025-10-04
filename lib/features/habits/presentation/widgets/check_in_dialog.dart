import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../providers/habit_provider.dart';

/// 打卡对话框 - 支持质量评分和成功动画
class CheckInDialog extends ConsumerStatefulWidget {
  final Habit habit;

  const CheckInDialog({
    super.key,
    required this.habit,
  });

  @override
  ConsumerState<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends ConsumerState<CheckInDialog>
    with SingleTickerProviderStateMixin {
  int? _selectedQuality; // 1-5 星评分
  final _notesController = TextEditingController();
  bool _isSubmitting = false;
  bool _showSuccessAnimation = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(habitRepositoryProvider);
      final now = DateTime.now();

      final record = HabitRecord(
        id: '${widget.habit.id}_${now.millisecondsSinceEpoch}',
        habitId: widget.habit.id,
        executedAt: now,
        quality: _selectedQuality,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        isBackfilled: false,
        createdAt: now,
      );

      await repository.recordExecution(record);

      // 显示成功动画
      setState(() {
        _showSuccessAnimation = true;
      });
      _animationController.forward();

      // 延迟关闭对话框
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('打卡失败'),
            content: Text(e.toString()),
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

  @override
  Widget build(BuildContext context) {
    if (_showSuccessAnimation) {
      return _buildSuccessAnimation();
    }

    return CupertinoAlertDialog(
      title: Text(widget.habit.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            '今日打卡',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const Text(
            '质量评分（可选）',
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 8),
          // 星级评分
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              return CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                onPressed: () {
                  setState(() {
                    _selectedQuality = star;
                  });
                },
                child: Icon(
                  _selectedQuality != null && star <= _selectedQuality!
                      ? CupertinoIcons.star_fill
                      : CupertinoIcons.star,
                  color: _selectedQuality != null && star <= _selectedQuality!
                      ? CupertinoColors.systemYellow
                      : CupertinoColors.systemGrey3,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          // 笔记输入
          CupertinoTextField(
            controller: _notesController,
            placeholder: '记录感想（可选）...',
            maxLines: 3,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              border: Border.all(
                color: CupertinoColors.separator,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const CupertinoActivityIndicator()
              : const Text('完成打卡'),
        ),
      ],
    );
  }

  Widget _buildSuccessAnimation() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 成功图标动画
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 80,
                  color: CupertinoColors.activeGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 成功文本
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    '打卡成功！',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.habit.reward,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 显示打卡对话框的辅助函数
Future<bool?> showCheckInDialog(BuildContext context, Habit habit) {
  return showCupertinoDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CheckInDialog(habit: habit),
  );
}
