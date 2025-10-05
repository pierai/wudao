import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit_frontmatter.dart';
import '../providers/habit_provider.dart';

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
  late TextEditingController _tagsController;

  bool _isPreviewMode = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.frontmatter?.title ?? '');
    _contentController =
        TextEditingController(text: widget.frontmatter?.content ?? '');
    _tagsController = TextEditingController(
      text: widget.frontmatter?.tags.join(', ') ?? '',
    );

    // 监听内容变化
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
    _tagsController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
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

      // 解析标签
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      if (widget.frontmatter == null) {
        // 创建新感悟
        final frontmatter = HabitFrontmatter(
          id: 'frontmatter_${now.millisecondsSinceEpoch}',
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: tags,
          createdAt: now,
          updatedAt: now,
        );

        await repository.createFrontmatter(frontmatter);
      } else {
        // 更新现有感悟
        final frontmatter = widget.frontmatter!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: tags,
          updatedAt: now,
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
          middle: Text(widget.frontmatter == null ? '新建感悟' : '编辑感悟'),
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

          // 标签输入
          Row(
            children: [
              const Text(
                '标签: ',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              Expanded(
                child: CupertinoTextField(
                  controller: _tagsController,
                  placeholder: '多个标签用逗号分隔',
                  style: const TextStyle(fontSize: 14),
                  decoration: null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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
          if (_tagsController.text.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tagsController.text.split(',').map((tag) {
                final trimmedTag = tag.trim();
                if (trimmedTag.isEmpty) return const SizedBox.shrink();

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
                    trimmedTag,
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
}
