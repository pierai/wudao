import 'package:flutter/cupertino.dart';

import '../../../habits/presentation/screens/export_screen.dart';
import '../../../habits/presentation/screens/import_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('我的'),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 40),
            // 头像和用户信息
            const Column(
              children: [
                Icon(
                  CupertinoIcons.person_circle_fill,
                  size: 100,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(height: 16),
                Text(
                  '悟道者',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '持续成长中...',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 数据管理
            CupertinoListSection.insetGrouped(
              header: const Text('数据管理'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.square_arrow_up),
                  title: const Text('导出数据'),
                  subtitle: const Text('备份数据到文件'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const ExportScreen(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.square_arrow_down),
                  title: const Text('导入数据'),
                  subtitle: const Text('从文件恢复数据'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const ImportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 设置列表
            CupertinoListSection.insetGrouped(
              header: const Text('其他'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.settings),
                  title: const Text('设置'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: const Text('关于'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
