import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('我的'),
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
            // 设置列表
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.settings),
                  title: const Text('设置'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.cloud),
                  title: const Text('数据同步'),
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
