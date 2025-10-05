import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';

/// 习惯创建/编辑表单页面
class HabitFormScreen extends ConsumerStatefulWidget {
  final String? habitId; // null 表示创建新习惯，非 null 表示编辑

  const HabitFormScreen({
    super.key,
    this.habitId,
  });

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 表单控制器
  final _nameController = TextEditingController();
  final _cueController = TextEditingController();
  final _routineController = TextEditingController();
  final _oldRoutineController = TextEditingController();
  final _rewardController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  // 习惯类型选择
  HabitType _selectedType = HabitType.positive;

  // 是否为核心习惯
  bool _isKeystone = false;

  // 表单验证错误信息
  String? _nameError;
  String? _cueError;
  String? _routineError;
  String? _oldRoutineError;
  String? _rewardError;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 如果是编辑模式，加载习惯数据
    if (widget.habitId != null) {
      _loadHabitData();
    }
  }

  Future<void> _loadHabitData() async {
    final repository = ref.read(habitRepositoryProvider);
    final habit = await repository.getHabitById(widget.habitId!);

    if (habit != null && mounted) {
      setState(() {
        _nameController.text = habit.name;
        _cueController.text = habit.cue ?? '';
        _routineController.text = habit.routine;
        _oldRoutineController.text = habit.oldRoutine ?? '';
        _rewardController.text = habit.reward ?? '';
        _categoryController.text = habit.category ?? '';
        _notesController.text = habit.notes ?? '';
        _selectedType = habit.type;
        _isKeystone = habit.isKeystone;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cueController.dispose();
    _routineController.dispose();
    _oldRoutineController.dispose();
    _rewardController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      // 验证习惯名称
      if (_nameController.text.trim().isEmpty) {
        _nameError = '请输入习惯名称';
        isValid = false;
      } else if (_nameController.text.trim().length > 100) {
        _nameError = '习惯名称不能超过 100 个字符';
        isValid = false;
      } else {
        _nameError = null;
      }

      // 验证暗示（可选）
      if (_cueController.text.trim().length > 500) {
        _cueError = '暗示不能超过 500 个字符';
        isValid = false;
      } else {
        _cueError = null;
      }

      // 验证惯常行为
      if (_routineController.text.trim().isEmpty) {
        _routineError = '请输入惯常行为';
        isValid = false;
      } else if (_routineController.text.trim().length > 500) {
        _routineError = '惯常行为不能超过 500 个字符';
        isValid = false;
      } else {
        _routineError = null;
      }

      // 验证原惯常行为（仅习惯替代类型需要）
      if (_selectedType == HabitType.replacement) {
        if (_oldRoutineController.text.trim().isEmpty) {
          _oldRoutineError = '请输入原惯常行为';
          isValid = false;
        } else if (_oldRoutineController.text.trim().length > 500) {
          _oldRoutineError = '原惯常行为不能超过 500 个字符';
          isValid = false;
        } else {
          _oldRoutineError = null;
        }
      } else {
        _oldRoutineError = null;
      }

      // 验证奖赏（可选）
      if (_rewardController.text.trim().length > 500) {
        _rewardError = '奖赏不能超过 500 个字符';
        isValid = false;
      } else {
        _rewardError = null;
      }
    });

    return isValid;
  }

  Future<void> _handleSave() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(habitRepositoryProvider);
      final now = DateTime.now();

      final habit = Habit(
        id: widget.habitId ?? 'habit_${now.millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        cue: _cueController.text.trim().isNotEmpty
            ? _cueController.text.trim()
            : null,
        routine: _routineController.text.trim(),
        oldRoutine: _selectedType == HabitType.replacement
            ? _oldRoutineController.text.trim()
            : null,
        reward: _rewardController.text.trim().isNotEmpty
            ? _rewardController.text.trim()
            : null,
        type: _selectedType,
        category: _categoryController.text.trim().isNotEmpty
            ? _categoryController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        isActive: true,
        isKeystone: _isKeystone,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      );

      if (widget.habitId == null) {
        // 创建新习惯
        await repository.createHabit(habit);
      } else {
        // 更新现有习惯
        await repository.updateHabit(habit);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('保存失败'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.habitId == null ? '创建习惯' : '编辑习惯'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const CupertinoActivityIndicator()
              : const Text('保存'),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 习惯类型选择
              const Text(
                '习惯类型',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoSegmentedControl<HabitType>(
                groupValue: _selectedType,
                onValueChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    // 切换到正向习惯时清空原惯常行为
                    if (value == HabitType.positive) {
                      _oldRoutineController.clear();
                      _oldRoutineError = null;
                    }
                  });
                },
                children: const {
                  HabitType.positive: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('正向习惯'),
                  ),
                  HabitType.replacement: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('习惯替代'),
                  ),
                },
              ),
              const SizedBox(height: 24),

              // 习惯名称
              _buildTextField(
                label: '习惯名称',
                controller: _nameController,
                placeholder: '例如：每天阅读',
                errorText: _nameError,
                maxLength: 100,
              ),
              const SizedBox(height: 16),

              // 暗示（Cue）
              _buildTextField(
                label: '暗示（触发条件）（可选）',
                controller: _cueController,
                placeholder: '例如：晚饭后坐在书桌前',
                errorText: _cueError,
                maxLength: 500,
                maxLines: 3,
                helperText: '什么情境或信号会触发这个习惯？',
              ),
              const SizedBox(height: 16),

              // 原惯常行为（仅习惯替代类型）
              if (_selectedType == HabitType.replacement) ...[
                _buildTextField(
                  label: '原惯常行为（要改变的行为）',
                  controller: _oldRoutineController,
                  placeholder: '例如：刷手机',
                  errorText: _oldRoutineError,
                  maxLength: 500,
                  maxLines: 3,
                  helperText: '你想要改变的不良行为是什么？',
                ),
                const SizedBox(height: 16),
              ],

              // 惯常行为（Routine）
              _buildTextField(
                label: _selectedType == HabitType.positive
                    ? '惯常行为（要养成的行为）'
                    : '新惯常行为（替代行为）',
                controller: _routineController,
                placeholder: _selectedType == HabitType.positive
                    ? '例如：阅读 30 分钟'
                    : '例如：做 10 个深蹲',
                errorText: _routineError,
                maxLength: 500,
                maxLines: 3,
                helperText: _selectedType == HabitType.positive
                    ? '你要执行的具体行为是什么？'
                    : '用什么行为替代原来的不良行为？',
              ),
              const SizedBox(height: 16),

              // 奖赏（Reward）
              _buildTextField(
                label: '奖赏（获得的满足）（可选）',
                controller: _rewardController,
                placeholder: '例如：获得新知识，内心充实',
                errorText: _rewardError,
                maxLength: 500,
                maxLines: 3,
                helperText: '这个行为会带来什么满足感或收益？',
              ),
              const SizedBox(height: 16),

              // 分类（可选）
              _buildTextField(
                label: '分类（可选）',
                controller: _categoryController,
                placeholder: '例如：健康、学习、工作',
                maxLength: 50,
              ),
              const SizedBox(height: 24),

              // 核心习惯开关
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💎 核心习惯',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '核心习惯能引发连锁反应，带动其他习惯形成',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey.resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: _isKeystone,
                      onChanged: (value) {
                        setState(() {
                          _isKeystone = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 备注（可选）
              _buildTextField(
                label: '备注（可选）',
                controller: _notesController,
                placeholder: '其他说明...',
                maxLines: 4,
                maxLength: 1000,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    String? errorText,
    String? helperText,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          maxLength: maxLength,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            border: Border.all(
              color: errorText != null
                  ? CupertinoColors.systemRed
                  : CupertinoColors.separator,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemRed,
            ),
          ),
        ],
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ],
    );
  }
}
