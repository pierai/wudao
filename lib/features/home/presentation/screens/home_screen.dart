import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_glass_bottom_bar.dart';
import '../../../goals/presentation/screens/goals_screen.dart';
import '../../../habits/presentation/screens/habits_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../reflections/presentation/screens/reflections_screen.dart';

// 当前选中的底部导航索引的 Notifier
class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(SelectedIndexNotifier.new);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final List<Widget> pages = [const GoalsScreen(), const HabitsScreen(), const ReflectionsScreen(), const ProfileScreen()];

    // 使用 viewPadding.bottom（设备物理安全区域，不受键盘影响）
    // final bottomSafePadding = MediaQuery.of(context).viewPadding.bottom;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false, // 防止键盘展开时，导航栏被顶起来
      child: Stack(
        children: [
          // 页面内容
          IndexedStack(index: selectedIndex, children: pages),
          // 底部导航栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // viewInsets: EdgeInsets.zero, // 移除键盘的影响
                padding: MediaQuery.of(context).viewPadding.copyWith(
                  bottom: 0, // 使用 0， 更贴近底部
                  // bottom: bottomSafePadding, // 使用设备固有的底部安全区域
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: CustomGlassBottomBar(
                  margin: const EdgeInsets.all(16),
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    ref.read(selectedIndexProvider.notifier).setIndex(index);
                  },
                  borderRadius: 32, // 更大的圆角
                  backgroundAlpha: 25, // 更透明，不那么灰
                  activeColor: const Color(0xFF007AFF), // iOS系统蓝
                  items: const [
                    CustomGlassBottomBarItem(icon: CupertinoIcons.flag, label: '目标'),
                    CustomGlassBottomBarItem(icon: CupertinoIcons.chart_bar, label: '习惯'),
                    CustomGlassBottomBarItem(icon: CupertinoIcons.lightbulb, label: '灵感'),
                    CustomGlassBottomBarItem(icon: CupertinoIcons.person, label: '我的'),
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
