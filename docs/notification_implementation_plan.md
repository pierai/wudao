# 明日计划提醒功能实现方案

## 当前状态

✅ 数据库已支持 `scheduledTime` 字段 (在 `daily_plans` 表中)
✅ UI 已显示计划时间 (在 `daily_plan_screen.dart:360-378`)

## 实现步骤

### 1. 添加依赖

在 `pubspec.yaml` 中添加:

```yaml
dependencies:
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2
```

### 2. iOS 配置

修改 `ios/Runner/Info.plist` 添加通知权限:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### 3. 创建通知服务

创建 `lib/core/services/notification_service.dart`:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> schedulePlanNotification({
    required String planId,
    required String title,
    required DateTime scheduledTime,
  }) async {
    await _notifications.zonedSchedule(
      planId.hashCode,
      '📅 明日计划提醒',
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelPlanNotification(String planId) async {
    await _notifications.cancel(planId.hashCode);
  }
}
```

### 4. 集成到计划生成流程

在 `plan_generator_dialog.dart` 中生成计划时调用:

```dart
// 生成计划后
if (plan.scheduledTime != null) {
  await NotificationService.schedulePlanNotification(
    planId: plan.id,
    title: plan.cueTask,
    scheduledTime: plan.scheduledTime!,
  );
}
```

### 5. 删除计划时取消通知

在删除计划时:

```dart
await NotificationService.cancelPlanNotification(plan.id);
```

## 未来优化方向

1. **提前提醒**: 支持提前 5/10/15 分钟提醒
2. **重复提醒**: 对于未完成的计划可以设置重复提醒
3. **通知分组**: 同一时间的多个计划合并通知
4. **通知动作**: 点击通知直接打开对应计划
5. **勿扰模式**: 支持设置勿扰时间段

## 注意事项

- iOS 需要用户手动授权通知权限
- 需要在应用启动时初始化通知服务
- 时区处理需要使用 `timezone` 包
- 后台通知调度依赖系统,不保证 100% 准时
