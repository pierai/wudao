import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wudao/core/services/notification_service.dart';
import 'package:wudao/core/services/reminder_scheduler_service.dart';

/// 通知服务 Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// 提醒调度服务 Provider
final reminderSchedulerServiceProvider = Provider<ReminderSchedulerService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return ReminderSchedulerService(notificationService);
});

/// 通知权限状态 Provider
final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  final notificationService = ref.watch(notificationServiceProvider);
  return await notificationService.checkPermissions();
});
