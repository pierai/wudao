import 'package:flutter/cupertino.dart';

/// 应用颜色常量
class AppColors {
  AppColors._();

  // 主题色
  static const primary = CupertinoColors.systemBlue;
  static const secondary = CupertinoColors.systemTeal;

  // 功能色
  static const success = CupertinoColors.systemGreen;
  static const warning = CupertinoColors.systemOrange;
  static const error = CupertinoColors.systemRed;
  static const info = CupertinoColors.systemBlue;

  // 文字颜色
  static const textPrimary = CupertinoColors.label;
  static const textSecondary = CupertinoColors.secondaryLabel;
  static const textTertiary = CupertinoColors.tertiaryLabel;

  // 背景色
  static const background = CupertinoColors.systemBackground;
  static const secondaryBackground = CupertinoColors.secondarySystemBackground;
  static const tertiaryBackground = CupertinoColors.tertiarySystemBackground;

  // 分割线
  static const separator = CupertinoColors.separator;

  // 玻璃效果
  static const glassBackground = Color(0x80FFFFFF);
  static const glassBorder = Color(0x40FFFFFF);
}
