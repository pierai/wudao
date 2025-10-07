import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// 本地通知服务
///
/// 负责管理应用的本地通知功能,包括:
/// - 通知初始化和权限请求
/// - 计划提醒的调度和取消
/// - 通知点击事件处理
class NotificationService {
  // 单例模式
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 通知是否已初始化
  bool _isInitialized = false;

  /// 初始化通知服务
  ///
  /// [onNotificationTap] 通知点击回调,参数为 payload (通常是计划ID)
  Future<void> initialize({
    required Function(String?) onNotificationTap,
  }) async {
    if (_isInitialized) return;

    // 初始化时区数据
    tz.initializeTimeZones();
    // 设置本地时区为中国上海
    tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));

    // iOS 初始化设置
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Android 初始化设置
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    // 初始化插件
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 处理通知点击事件
        onNotificationTap(response.payload);
      },
    );

    _isInitialized = true;
  }

  /// 请求通知权限
  ///
  /// 返回是否授予权限
  Future<bool> requestPermissions() async {
    // iOS 请求权限
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? false;
  }

  /// 检查通知权限状态
  Future<bool> checkPermissions() async {
    // iOS 检查权限
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();

    return result?.isEnabled ?? false;
  }

  /// 调度计划提醒通知
  ///
  /// [id] 通知ID (使用计划ID的哈希值)
  /// [title] 通知标题
  /// [body] 通知内容
  /// [scheduledDate] 提醒时间
  /// [payload] 通知点击后传递的数据 (通常是计划ID)
  Future<void> schedulePlanReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // 通知详情
    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      ),
      android: AndroidNotificationDetails(
        'daily_plan_channel', // 渠道ID
        '次日计划提醒', // 渠道名称
        channelDescription: '提醒您执行次日计划中的习惯暗示',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
      ),
    );

    // 转换为时区感知的时间
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // 调度通知
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// 取消指定通知
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 获取待处理的通知列表
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// 显示即时通知 (用于测试)
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        'instant_channel',
        '即时通知',
        channelDescription: '用于测试的即时通知',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
