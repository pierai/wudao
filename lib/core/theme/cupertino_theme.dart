import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';

/// Cupertino 主题配置
class AppCupertinoTheme {
  AppCupertinoTheme._();

  static const _defaultTextStyle = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17.0,
    letterSpacing: -0.41,
    color: AppColors.textPrimary,
  );

  static CupertinoThemeData get lightTheme => const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.secondaryBackground,
        textTheme: CupertinoTextThemeData(
          textStyle: _defaultTextStyle,
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            color: AppColors.textPrimary,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.41,
            color: AppColors.textPrimary,
          ),
          navActionTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17.0,
            letterSpacing: -0.41,
            color: AppColors.primary,
          ),
          tabLabelTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 10.0,
            letterSpacing: -0.24,
            color: AppColors.textSecondary,
          ),
        ),
      );

  static CupertinoThemeData get darkTheme => const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        primaryContrastingColor: CupertinoColors.black,
        scaffoldBackgroundColor: CupertinoColors.black,
        barBackgroundColor: CupertinoColors.systemGrey6,
        textTheme: CupertinoTextThemeData(
          textStyle: _defaultTextStyle,
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            color: CupertinoColors.white,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.41,
            color: CupertinoColors.white,
          ),
          navActionTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17.0,
            letterSpacing: -0.41,
            color: AppColors.primary,
          ),
          tabLabelTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 10.0,
            letterSpacing: -0.24,
            color: CupertinoColors.systemGrey,
          ),
        ),
      );
}
