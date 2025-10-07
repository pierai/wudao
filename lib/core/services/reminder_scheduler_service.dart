import 'package:wudao/core/services/notification_service.dart';
import 'package:wudao/features/habits/domain/entities/daily_plan.dart';

/// 提醒调度服务
///
/// 负责为次日计划创建、更新和取消提醒通知
class ReminderSchedulerService {
  final NotificationService _notificationService;

  ReminderSchedulerService(this._notificationService);

  /// 为计划调度提醒通知
  ///
  /// [plan] 次日计划
  /// [minutesBefore] 提前提醒分钟数 (0=准时, 5=提前5分钟, 等)
  Future<void> schedulePlanReminder(
    DailyPlan plan, {
    int minutesBefore = 0,
  }) async {
    // 如果计划没有设置提醒时间,跳过
    if (plan.scheduledTime == null) return;

    // 计算提醒时间
    final reminderTime =
        plan.scheduledTime!.subtract(Duration(minutes: minutesBefore));

    // 如果提醒时间已经过去,跳过
    if (reminderTime.isBefore(DateTime.now())) return;

    // 生成通知ID (使用计划ID的哈希值)
    final notificationId = plan.id.hashCode;

    // 通知标题和内容
    final title = '习惯提醒：${_formatTime(plan.scheduledTime!)}';
    final body = plan.cueTask;

    // 调度通知
    await _notificationService.schedulePlanReminder(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: reminderTime,
      payload: plan.id, // 传递计划ID,用于通知点击后跳转
    );
  }

  /// 更新计划提醒
  ///
  /// 先取消旧提醒,再创建新提醒
  Future<void> updatePlanReminder(
    DailyPlan plan, {
    int minutesBefore = 0,
  }) async {
    await cancelPlanReminder(plan.id);
    await schedulePlanReminder(plan, minutesBefore: minutesBefore);
  }

  /// 取消计划提醒
  Future<void> cancelPlanReminder(String planId) async {
    final notificationId = planId.hashCode;
    await _notificationService.cancelNotification(notificationId);
  }

  /// 批量调度计划提醒
  Future<void> scheduleBatchPlanReminders(
    List<DailyPlan> plans, {
    int minutesBefore = 0,
  }) async {
    for (final plan in plans) {
      await schedulePlanReminder(plan, minutesBefore: minutesBefore);
    }
  }

  /// 取消所有提醒
  Future<void> cancelAllReminders() async {
    await _notificationService.cancelAllNotifications();
  }

  /// 格式化时间 (HH:mm)
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 检查是否在免打扰时段
  ///
  /// [time] 要检查的时间
  /// [doNotDisturbStart] 免打扰开始时间 (如 22:00)
  /// [doNotDisturbEnd] 免打扰结束时间 (如 08:00)
  bool isInDoNotDisturbPeriod(
    DateTime time,
    TimeOfDay doNotDisturbStart,
    TimeOfDay doNotDisturbEnd,
  ) {
    final timeOfDay = TimeOfDay.fromDateTime(time);
    final timeInMinutes = timeOfDay.hour * 60 + timeOfDay.minute;
    final startInMinutes = doNotDisturbStart.hour * 60 + doNotDisturbStart.minute;
    final endInMinutes = doNotDisturbEnd.hour * 60 + doNotDisturbEnd.minute;

    // 处理跨午夜的情况 (如 22:00 - 08:00)
    if (startInMinutes > endInMinutes) {
      return timeInMinutes >= startInMinutes || timeInMinutes < endInMinutes;
    } else {
      return timeInMinutes >= startInMinutes && timeInMinutes < endInMinutes;
    }
  }
}

/// 时间工具类
class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute})
      : assert(hour >= 0 && hour < 24),
        assert(minute >= 0 && minute < 60);

  factory TimeOfDay.fromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  @override
  String toString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
