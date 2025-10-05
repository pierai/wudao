import 'package:flutter/cupertino.dart';

/// 标签选择器组件
///
/// 支持选择已有标签、添加新标签、删除已选标签
class TagSelectorWidget extends StatefulWidget {
  /// 当前已选标签列表
  final List<String> selectedTags;

  /// 所有可用标签列表
  final List<String> availableTags;

  /// 标签变化回调
  final ValueChanged<List<String>> onTagsChanged;

  const TagSelectorWidget({
    super.key,
    required this.selectedTags,
    required this.availableTags,
    required this.onTagsChanged,
  });

  @override
  State<TagSelectorWidget> createState() => _TagSelectorWidgetState();
}

class _TagSelectorWidgetState extends State<TagSelectorWidget> {
  final TextEditingController _newTagController = TextEditingController();
  bool _isAddingNewTag = false;

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isEmpty) return;
    if (widget.selectedTags.contains(trimmedTag)) return;

    final updatedTags = [...widget.selectedTags, trimmedTag];
    widget.onTagsChanged(updatedTags);
    _newTagController.clear();
    setState(() {
      _isAddingNewTag = false;
    });
  }

  void _removeTag(String tag) {
    final updatedTags = widget.selectedTags.where((t) => t != tag).toList();
    widget.onTagsChanged(updatedTags);
  }

  void _toggleTag(String tag) {
    if (widget.selectedTags.contains(tag)) {
      _removeTag(tag);
    } else {
      _addTag(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 建议标签 = 可用标签 - 已选标签
    final suggestedTags = widget.availableTags
        .where((tag) => !widget.selectedTags.contains(tag))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 已选标签
        if (widget.selectedTags.isNotEmpty) ...[
          const Text(
            '已选标签',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTags.map((tag) {
              return GestureDetector(
                onTap: () => _removeTag(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 16,
                        color: CupertinoColors.white,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // 建议标签
        if (suggestedTags.isNotEmpty && !_isAddingNewTag) ...[
          const Text(
            '建议标签',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestedTags.map((tag) {
              return GestureDetector(
                onTap: () => _toggleTag(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: CupertinoColors.systemGrey4,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.label,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        CupertinoIcons.add_circled,
                        size: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // 添加新标签
        if (_isAddingNewTag)
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _newTagController,
                  placeholder: '输入新标签...',
                  autofocus: true,
                  onSubmitted: _addTag,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.systemGrey4,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _addTag(_newTagController.text),
                child: const Icon(CupertinoIcons.check_mark_circled_solid),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _isAddingNewTag = false;
                    _newTagController.clear();
                  });
                },
                child: const Icon(CupertinoIcons.xmark_circle),
              ),
            ],
          )
        else
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _isAddingNewTag = true;
              });
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.add_circled, size: 20),
                SizedBox(width: 6),
                Text('添加新标签'),
              ],
            ),
          ),
      ],
    );
  }
}
