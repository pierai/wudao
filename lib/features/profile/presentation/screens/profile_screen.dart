import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../routing/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onTap: () => AppRouter.toExportData(context),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.square_arrow_down),
                  title: const Text('导入数据'),
                  subtitle: const Text('从文件恢复数据'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => AppRouter.toImportData(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 开发者选项
            CupertinoListSection.insetGrouped(
              header: const Text('开发者选项'),
              children: [
                CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.trash,
                    color: CupertinoColors.systemRed,
                  ),
                  title: const Text(
                    '清除所有数据',
                    style: TextStyle(color: CupertinoColors.systemRed),
                  ),
                  subtitle: const Text('删除数据库和应用数据（用于开发测试）'),
                  onTap: () => _showClearDataDialog(context, ref),
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

  /// 显示清除数据确认对话框
  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('清除所有数据'),
        content: const Text(
          '此操作将删除所有习惯、打卡记录、计划和目标数据。\n\n'
          '⚠️ 此操作不可恢复！\n\n'
          '建议在清除前先导出数据进行备份。',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              await _clearAllData(context, ref);
            },
            child: const Text('确认清除'),
          ),
        ],
      ),
    );
  }

  /// 清除所有数据
  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    // 显示加载指示器
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CupertinoActivityIndicator(radius: 20),
      ),
    );

    try {
      // 1. 关闭数据库连接
      final database = ref.read(databaseProvider);
      await database.close();

      // 2. 删除数据库文件
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${appDocDir.path}/wudao.db');
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      // 3. 可选：清除其他应用数据
      // 如果有其他缓存或设置文件，也可以在这里删除

      if (context.mounted) {
        // 关闭加载指示器
        Navigator.of(context).pop();

        // 显示成功提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('清除成功'),
            content: const Text('所有数据已清除。\n\n请重启应用以使更改生效。'),
            actions: [
              CupertinoDialogAction(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // 在 macOS 上可以选择退出应用
                  if (Platform.isMacOS || Platform.isIOS) {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // 关闭加载指示器
        Navigator.of(context).pop();

        // 显示错误提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('清除失败'),
            content: Text('错误：$e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('确定'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }
}
