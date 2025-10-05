import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit_frontmatter.dart';
import '../providers/habit_provider.dart';
import 'frontmatter_editor_screen.dart';

/// Frontmatter 习惯感悟列表页面
///
/// 显示所有习惯感悟记录，支持搜索和按标签筛选
class FrontmatterListScreen extends ConsumerStatefulWidget {
  const FrontmatterListScreen({super.key});

  @override
  ConsumerState<FrontmatterListScreen> createState() =>
      _FrontmatterListScreenState();
}

class _FrontmatterListScreenState extends ConsumerState<FrontmatterListScreen> {
  String _searchQuery = '';
  String? _selectedTag;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToEditor({HabitFrontmatter? frontmatter}) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FrontmatterEditorScreen(
          frontmatter: frontmatter,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(allFrontmattersProvider);
  }

  Future<void> _handleDelete(HabitFrontmatter frontmatter) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('删除感悟'),
        content: Text('确定要删除《${frontmatter.title}》吗？'),
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
      await repository.deleteFrontmatter(frontmatter.id);
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根据搜索和标签选择数据源
    final frontmattersAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchFrontmattersProvider(_searchQuery))
        : _selectedTag != null
            ? ref.watch(frontmattersByTagProvider(_selectedTag!))
            : ref.watch(allFrontmattersProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('习惯感悟'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _navigateToEditor(),
          child: const Icon(CupertinoIcons.add_circled),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 搜索栏
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: '搜索感悟...',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // 标签筛选（TODO: 后续实现）
            // if (_searchQuery.isEmpty) _buildTagFilter(),

            // 感悟列表
            Expanded(
              child: frontmattersAsync.when(
                data: (frontmatters) {
                  if (frontmatters.isEmpty) {
                    return _buildEmptyState();
                  }

                  // 按更新时间降序排序
                  final sortedFrontmatters = [...frontmatters]
                    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

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
                              final frontmatter = sortedFrontmatters[index];
                              return _buildFrontmatterCard(frontmatter);
                            },
                            childCount: sortedFrontmatters.length,
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

  Widget _buildFrontmatterCard(HabitFrontmatter frontmatter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(frontmatter.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('删除感悟'),
              content: Text('确定要删除《${frontmatter.title}》吗？'),
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
        onDismissed: (direction) => _handleDelete(frontmatter),
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
          onTap: () => _navigateToEditor(frontmatter: frontmatter),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  frontmatter.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // 内容预览
                if (frontmatter.content.isNotEmpty)
                  Text(
                    _getContentPreview(frontmatter.content),
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 12),

                // 标签和日期
                Row(
                  children: [
                    // 标签
                    if (frontmatter.tags.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: frontmatter.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey5,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // 更新时间
                    Text(
                      _formatDate(frontmatter.updatedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
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
            CupertinoIcons.doc_text,
            size: 80,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '还没有习惯感悟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击右上角 + 号记录你的感悟',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: () => _navigateToEditor(),
            child: const Text('写下感悟'),
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

  /// 获取内容预览（去除 Markdown 格式）
  String _getContentPreview(String content) {
    // 简单处理：去除标题符号
    String preview = content
        .replaceAll(RegExp(r'^#+\s+', multiLine: true), '')
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1') // 去除加粗
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1') // 去除斜体
        .replaceAll(RegExp(r'`(.+?)`'), r'$1') // 去除代码
        .replaceAll(RegExp(r'\[(.+?)\]\(.+?\)'), r'$1') // 去除链接
        .trim();

    return preview;
  }

  /// 格式化日期显示
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '今天 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
