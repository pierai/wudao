import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/cupertino_theme.dart';
import 'core/constants/app_strings.dart';
import 'routing/app_router.dart';

class WuDaoApp extends ConsumerWidget {
  const WuDaoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp(
      title: AppStrings.appName,
      theme: AppCupertinoTheme.lightTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      onUnknownRoute: AppRouter.onUnknownRoute,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
