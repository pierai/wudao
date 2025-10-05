import 'package:flutter/cupertino.dart';
import '../features/habits/domain/entities/habit_frontmatter.dart';
import '../features/habits/presentation/screens/daily_plan_screen.dart';
import '../features/habits/presentation/screens/export_screen.dart';
import '../features/habits/presentation/screens/frontmatter_editor_screen.dart';
import '../features/habits/presentation/screens/frontmatter_list_screen.dart';
import '../features/habits/presentation/screens/habit_detail_screen.dart';
import '../features/habits/presentation/screens/habit_form_screen.dart';
import '../features/habits/presentation/screens/habits_screen.dart';
import '../features/habits/presentation/screens/import_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

/// 应用路由配置
class AppRouter {
  // 路由名称常量
  static const String home = '/';
  static const String habits = '/habits';
  static const String habitNew = '/habits/new';
  static const String habitDetail = '/habits/detail';
  static const String habitEdit = '/habits/edit';
  static const String dailyPlan = '/habits/daily-plan';
  static const String frontmatterList = '/habits/frontmatter';
  static const String frontmatterNew = '/habits/frontmatter/new';
  static const String frontmatterEdit = '/habits/frontmatter/edit';
  static const String exportData = '/habits/export';
  static const String importData = '/habits/import';

  /// 生成路由
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return CupertinoPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case habits:
        return CupertinoPageRoute(
          builder: (_) => const HabitsScreen(),
          settings: settings,
        );

      case habitNew:
        return CupertinoPageRoute(
          builder: (_) => const HabitFormScreen(),
          settings: settings,
          fullscreenDialog: true,
        );

      case habitDetail:
        final habitId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => HabitDetailScreen(habitId: habitId),
          settings: settings,
        );

      case habitEdit:
        final habitId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => HabitFormScreen(habitId: habitId),
          settings: settings,
          fullscreenDialog: true,
        );

      case dailyPlan:
        return CupertinoPageRoute(
          builder: (_) => const DailyPlanScreen(),
          settings: settings,
        );

      case frontmatterList:
        return CupertinoPageRoute(
          builder: (_) => const FrontmatterListScreen(),
          settings: settings,
        );

      case frontmatterNew:
        return CupertinoPageRoute(
          builder: (_) => const FrontmatterEditorScreen(),
          settings: settings,
          fullscreenDialog: true,
        );

      case frontmatterEdit:
        final frontmatter = settings.arguments as HabitFrontmatter;
        return CupertinoPageRoute(
          builder: (_) => FrontmatterEditorScreen(frontmatter: frontmatter),
          settings: settings,
          fullscreenDialog: true,
        );

      case exportData:
        return CupertinoPageRoute(
          builder: (_) => const ExportScreen(),
          settings: settings,
        );

      case importData:
        return CupertinoPageRoute(
          builder: (_) => const ImportScreen(),
          settings: settings,
        );

      default:
        return null;
    }
  }

  /// 处理未知路由
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return CupertinoPageRoute(
      builder: (_) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('页面未找到'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.question_circle,
                size: 64,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(height: 16),
              const Text(
                '页面未找到',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '路由: ${settings.name}',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// 导航辅助方法

  /// 跳转到习惯列表
  static Future<void> toHabits(BuildContext context) {
    return Navigator.pushNamed(context, habits);
  }

  /// 跳转到创建习惯
  static Future<void> toHabitNew(BuildContext context) {
    return Navigator.pushNamed(context, habitNew);
  }

  /// 跳转到习惯详情
  static Future<void> toHabitDetail(BuildContext context, String habitId) {
    return Navigator.pushNamed(
      context,
      habitDetail,
      arguments: habitId,
    );
  }

  /// 跳转到编辑习惯
  static Future<void> toHabitEdit(BuildContext context, String habitId) {
    return Navigator.pushNamed(
      context,
      habitEdit,
      arguments: habitId,
    );
  }

  /// 跳转到次日计划
  static Future<void> toDailyPlan(BuildContext context) {
    return Navigator.pushNamed(context, dailyPlan);
  }

  /// 跳转到习惯感悟列表
  static Future<void> toFrontmatterList(BuildContext context) {
    return Navigator.pushNamed(context, frontmatterList);
  }

  /// 跳转到创建习惯感悟
  static Future<void> toFrontmatterNew(BuildContext context) {
    return Navigator.pushNamed(context, frontmatterNew);
  }

  /// 跳转到编辑习惯感悟
  static Future<void> toFrontmatterEdit(BuildContext context, HabitFrontmatter frontmatter) {
    return Navigator.pushNamed(
      context,
      frontmatterEdit,
      arguments: frontmatter,
    );
  }

  /// 跳转到数据导出
  static Future<void> toExportData(BuildContext context) {
    return Navigator.pushNamed(context, exportData);
  }

  /// 跳转到数据导入
  static Future<void> toImportData(BuildContext context) {
    return Navigator.pushNamed(context, importData);
  }
}
