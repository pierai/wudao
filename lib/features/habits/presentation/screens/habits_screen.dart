import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'habit_form_screen.dart';

/// 习惯列表页面
class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHabitForm(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const HabitFormScreen(),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // 刷新习惯列表
    ref.invalidate(activeHabitsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = _searchQuery.isEmpty
        ? ref.watch(activeHabitsProvider)
        : ref.watch(searchHabitsProvider(_searchQuery));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('习惯追踪'),
        transitionBetweenRoutes: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled),
          onPressed: () => _navigateToHabitForm(context),
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
            // 习惯列表
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) {
                    return _buildEmptyState();
                  }
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
            child: const Text('重试'),
            onPressed: _handleRefresh,
          ),
        ],
      ),
    );
  }
}
