import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit_frontmatter.dart';
import '../providers/habit_provider.dart';
import '../widgets/tag_selector_widget.dart';

/// Frontmatter 编辑器页面
///
/// 支持 Markdown 编辑、预览、YAML frontmatter 编辑
class FrontmatterEditorScreen extends ConsumerStatefulWidget {
  final HabitFrontmatter? frontmatter;

  const FrontmatterEditorScreen({
    super.key,
    this.frontmatter,
  });

  @override
  ConsumerState<FrontmatterEditorScreen> createState() =>
      _FrontmatterEditorScreenState();
}

class _FrontmatterEditorScreenState
    extends ConsumerState<FrontmatterEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late List<String> _selectedTags;

  bool _isPreviewMode = false;
  bool _hasUnsavedChanges = false;
  bool _isSavingDraft = false;
  DateTime? _lastAutoSaveTime;
  Timer? _autoSaveTimer;

  // 自动保存间隔（30秒）
  static const _autoSaveDuration = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.frontmatter?.title ?? '');
    _contentController =
        TextEditingController(text: widget.frontmatter?.content ?? '');
    _selectedTags = widget.frontmatter?.tags ?? [];

    // 监听内容变化
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);

    // 启动自动保存定时器
    _startAutoSave();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  /// 启动自动保存定时器
  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(_autoSaveDuration, (timer) {
      if (_hasUnsavedChanges && !_isSavingDraft) {
        _saveDraft();
      }
    });
  }

  /// 自动保存草稿
  Future<void> _saveDraft() async {
    // 如果标题为空，不保存草稿
    if (_titleController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isSavingDraft = true;
    });

    try {
      final repository = ref.read(habitRepositoryProvider);
      final now = DateTime.now();

      if (widget.frontmatter == null) {
        // 创建新草稿
        final frontmatter = HabitFrontmatter(
          id: 'frontmatter_${now.millisecondsSinceEpoch}',
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
          createdAt: now,
          updatedAt: now,
          metadata: {'isDraft': true}, // 标记为草稿
        );

        await repository.createFrontmatter(frontmatter);
      } else {
        // 更新现有草稿
        final frontmatter = widget.frontmatter!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
          updatedAt: now,
          metadata: widget.frontmatter!.metadata ?? {'isDraft': true},
        );

        await repository.updateFrontmatter(frontmatter);
      }

      setState(() {
        _hasUnsavedChanges = false;
        _lastAutoSaveTime = now;
      });
    } catch (e) {
      // 自动保存失败，不显示错误提示，静默失败
    } finally {
      setState(() {
        _isSavingDraft = false;
      });
    }
  }

  Future<bool> _handleWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final shouldPop = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('未保存的更改'),
        content: const Text('你有未保存的更改，确定要退出吗？'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('放弃'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Future<void> _handleSave() async {
    if (_titleController.text.trim().isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('标题不能为空'),
          content: const Text('请输入感悟标题'),
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

    try {
      final repository = ref.read(habitRepositoryProvider);
      final now = DateTime.now();

      if (widget.frontmatter == null) {
        // 创建新感悟（非草稿）
        final frontmatter = HabitFrontmatter(
          id: 'frontmatter_${now.millisecondsSinceEpoch}',
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
          createdAt: now,
          updatedAt: now,
          metadata: {'isDraft': false}, // 正式发布，非草稿
        );

        await repository.createFrontmatter(frontmatter);
      } else {
        // 更新现有感悟（移除草稿标记）
        final frontmatter = widget.frontmatter!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
          updatedAt: now,
          metadata: {...?widget.frontmatter!.metadata, 'isDraft': false},
        );

        await repository.updateFrontmatter(frontmatter);
      }

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        // 显示保存成功提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('保存成功'),
            content: const Text('你的感悟已保存'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                  Navigator.of(context).pop(); // 返回列表页
                },
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
            title: const Text('保存失败'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handleWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.frontmatter == null ? '新建感悟' : '编辑感悟'),
              if (_lastAutoSaveTime != null)
                Text(
                  '已自动保存 ${_formatAutoSaveTime(_lastAutoSaveTime!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              if (_isSavingDraft)
                const Text(
                  '保存中...',
                  style: TextStyle(
                    fontSize: 11,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
            ],
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final shouldPop = await _handleWillPop();
              if (shouldPop && mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('取消'),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 预览/编辑切换按钮
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _isPreviewMode = !_isPreviewMode;
                  });
                },
                child: Icon(
                  _isPreviewMode
                      ? CupertinoIcons.pencil
                      : CupertinoIcons.eye,
                ),
              ),
              // 保存按钮
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _handleSave,
                child: const Text(
                  '保存',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: _isPreviewMode ? _buildPreview() : _buildEditor(),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题输入
          CupertinoTextField(
            controller: _titleController,
            placeholder: '标题',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.separator,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),

          const SizedBox(height: 16),

          // 标签选择器
          Consumer(
            builder: (context, ref, child) {
              final availableTagsAsync = ref.watch(allAvailableTagsProvider);

              return availableTagsAsync.when(
                data: (availableTags) {
                  return TagSelectorWidget(
                    selectedTags: _selectedTags,
                    availableTags: availableTags,
                    onTagsChanged: (newTags) {
                      setState(() {
                        _selectedTags = newTags;
                        _hasUnsavedChanges = true;
                      });
                    },
                  );
                },
                loading: () => const CupertinoActivityIndicator(),
                error: (error, stack) => TagSelectorWidget(
                  selectedTags: _selectedTags,
                  availableTags: const [],
                  onTagsChanged: (newTags) {
                    setState(() {
                      _selectedTags = newTags;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Markdown 内容输入
          CupertinoTextField(
            controller: _contentController,
            placeholder: '在这里写下你的感悟...\n\n支持 Markdown 格式',
            maxLines: null,
            minLines: 20,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
            decoration: null,
          ),

          const SizedBox(height: 100), // 底部留白
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            _titleController.text.isNotEmpty
                ? _titleController.text
                : '无标题',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // 标签
          if (_selectedTags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 24),

          // Markdown 内容预览
          if (_contentController.text.isNotEmpty)
            MarkdownBody(
              data: _contentController.text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
                h1: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                h2: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                h3: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                listBullet: const TextStyle(
                  fontSize: 16,
                ),
                code: const TextStyle(
                  backgroundColor: CupertinoColors.systemGrey6,
                  fontFamily: 'Courier',
                ),
              ),
            )
          else
            const Text(
              '暂无内容',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey,
              ),
            ),

          const SizedBox(height: 100), // 底部留白
        ],
      ),
    );
  }

  /// 格式化自动保存时间
  String _formatAutoSaveTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分钟前';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
