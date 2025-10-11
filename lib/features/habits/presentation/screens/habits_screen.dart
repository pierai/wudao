import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/app_router.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';

/// 习惯Tab类型
enum HabitTabType {
  core, // 💪核心习惯
  replacement, // 🔄习惯替代
  positive, // ⬆️正向习惯
}

extension HabitTabTypeX on HabitTabType {
  String get displayName {
    switch (this) {
      case HabitTabType.positive:
        return '⬆️ 正向习惯';
      case HabitTabType.core:
        return '💪 核心习惯';
      case HabitTabType.replacement:
        return '🔄 习惯替代';
    }
  }

  Widget buildTabWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(displayName, style: const TextStyle(fontSize: 14)),
    );
  }
}

/// 习惯列表页面 - 带Tab布局
class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  HabitTabType _selectedTab = HabitTabType.core; // 默认选中核心习惯

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
    ref.invalidate(activeHabitsProvider);
  }

  /// 根据Tab筛选习惯
  List<Habit> _filterHabitsByTab(List<Habit> habits) {
    switch (_selectedTab) {
      case HabitTabType.positive:
        // 正向习惯：type=POSITIVE
        return habits.where((h) => h.type == HabitType.positive).toList();

      case HabitTabType.core:
        // 核心习惯：type=CORE
        return habits.where((h) => h.type == HabitType.core).toList();

      case HabitTabType.replacement:
        // 习惯替代：type=REPLACEMENT
        return habits.where((h) => h.type == HabitType.replacement).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根据搜索查询选择数据源
    final habitsAsync = _searchQuery.isEmpty ? ref.watch(activeHabitsProvider) : ref.watch(searchHabitsProvider(_searchQuery));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('习惯追踪'),
        transitionBetweenRoutes: false,
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

            // Tab栏（仅在非搜索状态显示）
            if (_searchQuery.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoSlidingSegmentedControl<HabitTabType>(
                  groupValue: _selectedTab,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTab = value;
                      });
                    }
                  },
                  children: {
                    HabitTabType.core: HabitTabType.core.buildTabWidget(),
                    HabitTabType.replacement: HabitTabType.replacement.buildTabWidget(),
                    HabitTabType.positive: HabitTabType.positive.buildTabWidget(),
                  },
                ),
              ),
            if (_searchQuery.isEmpty) const SizedBox(height: 12),

            // 习惯列表
            Expanded(
              child: _selectedTab == HabitTabType.core
                  ? _buildCoreHabitsTab() // 核心习惯Tab特殊布局
                  : _buildRegularHabitsTab(habitsAsync), // 其他Tab正常布局
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getEmptyIcon(), size: 80, color: CupertinoColors.systemGrey),
          const SizedBox(height: 16),
          Text(
            _getEmptyTitle(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptySubtitle(),
            style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(child: const Text('创建习惯'), onPressed: () => _navigateToHabitForm(context)),
        ],
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (_selectedTab) {
      case HabitTabType.positive:
        return CupertinoIcons.checkmark_circle;
      case HabitTabType.core:
        return CupertinoIcons.star_circle;
      case HabitTabType.replacement:
        return CupertinoIcons.arrow_2_circlepath;
    }
  }

  String _getEmptyTitle() {
    switch (_selectedTab) {
      case HabitTabType.positive:
        return '还没有正向习惯';
      case HabitTabType.core:
        return '还没有核心习惯';
      case HabitTabType.replacement:
        return '还没有习惯替代';
    }
  }

  String _getEmptySubtitle() {
    switch (_selectedTab) {
      case HabitTabType.positive:
        return '建立新的良好习惯\n持续提升自我';
      case HabitTabType.core:
        return '核心习惯能引发连锁反应\n带动其他习惯的形成';
      case HabitTabType.replacement:
        return '改变不良习惯\n保持相同的暗示和奖赏';
    }
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.exclamationmark_triangle, size: 60, color: CupertinoColors.systemRed),
          const SizedBox(height: 16),
          const Text('加载失败', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CupertinoButton(onPressed: _handleRefresh, child: const Text('重试')),
        ],
      ),
    );
  }

  /// 构建核心习惯Tab（分区布局 + 拖拽）
  Widget _buildCoreHabitsTab() {
    final coreHabitsAsync = ref.watch(activeHabitsProvider);
    final unassociatedHabitsAsync = ref.watch(unassociatedHabitsProvider);

    return coreHabitsAsync.when(
      data: (allHabits) {
        final coreHabits = allHabits.where((h) => h.type == HabitType.core).toList();

        return unassociatedHabitsAsync.when(
          data: (unassociatedHabits) {
            if (coreHabits.isEmpty && unassociatedHabits.isEmpty) {
              return _buildEmptyState();
            }

            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: _handleRefresh),

                // 核心习惯区
                if (coreHabits.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        '📂 核心习惯',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey.darkColor),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final habit = coreHabits[index];
                      return _buildCoreHabitCard(habit);
                    }, childCount: coreHabits.length),
                  ),
                ],

                // 分隔线
                if (coreHabits.isNotEmpty && unassociatedHabits.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    sliver: SliverToBoxAdapter(child: Container(height: 1, color: CupertinoColors.separator)),
                  ),

                // 未关联习惯区
                if (unassociatedHabits.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Text(
                            '未关联的习惯',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey.darkColor),
                          ),
                          const SizedBox(width: 8),
                          Icon(CupertinoIcons.hand_draw, size: 14, color: CupertinoColors.systemGrey.darkColor),
                          const SizedBox(width: 4),
                          Text('长按拖到核心习惯', style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final habit = unassociatedHabits[index];
                      return _buildDraggableHabitCard(habit);
                    }, childCount: unassociatedHabits.length),
                  ),
                ],
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator(radius: 16)),
          error: (error, stack) => _buildErrorState(error),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator(radius: 16)),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// 构建普通Tab的列表
  Widget _buildRegularHabitsTab(AsyncValue<List<Habit>> habitsAsync) {
    return habitsAsync.when(
      data: (habits) {
        final filteredHabits = _searchQuery.isEmpty ? _filterHabitsByTab(habits) : habits;

        if (filteredHabits.isEmpty) {
          return _buildEmptyState();
        }

        return CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: _handleRefresh),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final habit = filteredHabits[index];
                return _buildHabitCardWithAssociationBadge(habit);
              }, childCount: filteredHabits.length),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator(radius: 16)),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// 构建带关联标记的习惯卡片
  Widget _buildHabitCardWithAssociationBadge(Habit habit) {
    // 获取所有活跃习惯
    final habitsAsync = ref.watch(activeHabitsProvider);

    return habitsAsync.when(
      data: (allHabits) {
        // 检查是否被关联到任何核心习惯
        bool isAssociated = false;
        for (final coreHabit in allHabits.where((h) => h.type == HabitType.core)) {
          final associatedAsync = ref.watch(associatedHabitsProvider(coreHabit.id));
          associatedAsync.whenData((associated) {
            if (associated.any((h) => h.id == habit.id)) {
              isAssociated = true;
            }
          });
        }

        // 返回卡片，如果已关联则显示标记
        return Stack(
          children: [
            HabitCard(habit: habit, showAssociatedHabits: false),
            if (isAssociated)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(CupertinoIcons.link, size: 10, color: CupertinoColors.white),
                      SizedBox(width: 2),
                      Text(
                        '已关联',
                        style: TextStyle(fontSize: 10, color: CupertinoColors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => HabitCard(habit: habit, showAssociatedHabits: false),
      error: (_, __) => HabitCard(habit: habit, showAssociatedHabits: false),
    );
  }

  /// 构建核心习惯卡片（带DragTarget）
  Widget _buildCoreHabitCard(Habit coreHabit) {
    return DragTarget<Habit>(
      onWillAcceptWithDetails: (details) {
        // 只接受非核心习惯
        return details.data.type != HabitType.core;
      },
      onAcceptWithDetails: (details) async {
        // 创建关联
        await _createAssociation(coreHabit.id, details.data.id);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            border: isHovering ? Border.all(color: CupertinoColors.activeBlue, width: 2) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: HabitCard(habit: coreHabit, showAssociatedHabits: true),
        );
      },
    );
  }

  /// 构建可拖拽的习惯卡片
  Widget _buildDraggableHabitCard(Habit habit) {
    return LongPressDraggable<Habit>(
      data: habit,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: HabitCard(habit: habit, showAssociatedHabits: false),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: HabitCard(habit: habit, showAssociatedHabits: false)),
      child: HabitCard(habit: habit, showAssociatedHabits: false),
    );
  }

  /// 创建习惯关联
  Future<void> _createAssociation(String coreHabitId, String associatedHabitId) async {
    try {
      final repository = ref.read(habitRepositoryProvider);
      await repository.addHabitAssociation(keystoneHabitId: coreHabitId, associatedHabitId: associatedHabitId);

      if (mounted) {
        // 显示成功提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('关联成功'),
            content: const Text('习惯已关联到核心习惯'),
            actions: [CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(context), child: const Text('确定'))],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // 显示错误提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('关联失败'),
            content: Text(e.toString()),
            actions: [CupertinoDialogAction(onPressed: () => Navigator.pop(context), child: const Text('确定'))],
          ),
        );
      }
    }
  }
}
