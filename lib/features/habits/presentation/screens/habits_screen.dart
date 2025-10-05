import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../../../shared/widgets/custom_segmented_control.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';

/// 习惯列表页面
class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _groupByCategory = false; // 是否按分类分组
  final Map<String, bool> _expandedCategories = {}; // 记录每个分类的展开状态

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHabitForm(BuildContext context) {
    AppRouter.toHabitNew(context);
  }

  void _navigateToDailyPlan(BuildContext context) {
    AppRouter.toDailyPlan(context);
  }

  void _navigateToFrontmatter(BuildContext context) {
    AppRouter.toFrontmatterList(context);
  }

  Future<void> _handleRefresh() async {
    // 刷新习惯列表
    ref.invalidate(activeHabitsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final filterType = ref.watch(keystoneFilterProvider);

    // 根据搜索查询和筛选条件选择数据源
    final habitsAsync = _searchQuery.isEmpty
        ? ref.watch(filteredHabitsProvider)
        : ref.watch(searchHabitsProvider(_searchQuery));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('习惯追踪'),
        transitionBetweenRoutes: false,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              _groupByCategory = !_groupByCategory;
            });
          },
          child: Icon(
            _groupByCategory ? CupertinoIcons.list_bullet : CupertinoIcons.square_grid_2x2,
            size: 28,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _navigateToFrontmatter(context),
              child: const Icon(CupertinoIcons.doc_text),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _navigateToDailyPlan(context),
              child: const Icon(CupertinoIcons.calendar_today),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _navigateToHabitForm(context),
              child: const Icon(CupertinoIcons.add_circled),
            ),
          ],
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
                placeholder: '搜索习惯...',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            // 核心习惯筛选器（仅在非搜索状态显示）
            if (_searchQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomSegmentedControl<KeystoneFilterType>(
                  groupValue: filterType,
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(keystoneFilterProvider.notifier).state = value;
                    }
                  },
                  borderRadius: 12, // 增大圆角
                  children: const {
                    KeystoneFilterType.all: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('全部'),
                    ),
                    KeystoneFilterType.keystoneOnly: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('💎 核心'),
                    ),
                    KeystoneFilterType.regularOnly: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('普通'),
                    ),
                  },
                ),
              ),
            if (_searchQuery.isEmpty) const SizedBox(height: 12),
            // 习惯列表
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) {
                    return _buildEmptyState();
                  }

                  // 如果启用分组,按分类分组显示
                  if (_groupByCategory) {
                    return _buildGroupedHabitList(habits);
                  }

                  // 否则显示扁平列表
                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: _handleRefresh,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return HabitCard(habit: habits[index]);
                          },
                          childCount: habits.length,
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

  /// 构建分组习惯列表
  Widget _buildGroupedHabitList(List<Habit> habits) {
    // 按分类分组
    final Map<String, List<Habit>> groupedHabits = {};
    for (final habit in habits) {
      final category = habit.category ?? '未分类';
      groupedHabits.putIfAbsent(category, () => []);
      groupedHabits[category]!.add(habit);
    }

    // 按分类名称排序,未分类放最后
    final sortedCategories = groupedHabits.keys.toList()
      ..sort((a, b) {
        if (a == '未分类') return 1;
        if (b == '未分类') return -1;
        return a.compareTo(b);
      });

    // 初始化展开状态(默认都展开)
    for (final category in sortedCategories) {
      _expandedCategories.putIfAbsent(category, () => true);
    }

    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _handleRefresh,
        ),
        ...sortedCategories.expand((category) {
          final categoryHabits = groupedHabits[category]!;
          final isExpanded = _expandedCategories[category] ?? true;

          return [
            // 分类标题
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedCategories[category] = !isExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded
                            ? CupertinoIcons.chevron_down
                            : CupertinoIcons.chevron_right,
                        size: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${categoryHabits.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 分类下的习惯列表(可折叠)
            if (isExpanded)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return HabitCard(habit: categoryHabits[index]);
                  },
                  childCount: categoryHabits.length,
                ),
              ),
          ];
        }),
        // 底部留白
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.checkmark_seal,
            size: 80,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '还没有习惯',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击右上角 + 号创建第一个习惯',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            child: const Text('创建习惯'),
            onPressed: () => _navigateToHabitForm(context),
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
}
