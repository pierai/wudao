import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化通知服务
  final notificationService = NotificationService();
  await notificationService.initialize(
    onNotificationTap: (String? payload) {
      // TODO: 处理通知点击，跳转到计划详情
      debugPrint('通知被点击: payload=$payload');
    },
  );

  // 请求通知权限
  await notificationService.requestPermissions();

  runApp(
    const ProviderScope(
      child: WuDaoApp(),
    ),
  );
}
