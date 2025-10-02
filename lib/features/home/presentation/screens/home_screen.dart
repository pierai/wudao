import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';
import '../../../goals/presentation/screens/goals_screen.dart';
import '../../../habits/presentation/screens/habits_screen.dart';
import '../../../reflections/presentation/screens/reflections_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

// 当前选中的底部导航索引
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final List<Widget> pages = [
      const GoalsScreen(),
      const HabitsScreen(),
      const ReflectionsScreen(),
      const ProfileScreen(),
    ];

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // 页面内容
          IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
          // 底部导航栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Material(
                color: Colors.transparent,
                child: LiquidGlassBottomBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    ref.read(selectedIndexProvider.notifier).state = index;
                  },
                  items: const [
                    LiquidGlassBottomBarItem(
                      icon: CupertinoIcons.flag,
                      label: '目标',
                    ),
                    LiquidGlassBottomBarItem(
                      icon: CupertinoIcons.chart_bar,
                      label: '习惯',
                    ),
                    LiquidGlassBottomBarItem(
                      icon: CupertinoIcons.lightbulb,
                      label: '灵感',
                    ),
                    LiquidGlassBottomBarItem(
                      icon: CupertinoIcons.person,
                      label: '我的',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
