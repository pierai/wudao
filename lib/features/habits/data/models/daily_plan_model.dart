import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/daily_plan.dart';

/// DailyPlan 数据模型转换器

/// 从 DailyPlanData (Drift) 转换为 DailyPlan (Domain Entity)
extension DailyPlanDataToEntity on DailyPlanData {
  DailyPlan toEntity() {
    return DailyPlan(
      id: id,
      planDate: planDate,
      habitId: habitId,
      cueTask: cueTask,
      scheduledTime: scheduledTime,
      priority: priority,
      isCompleted: isCompleted,
      completedAt: completedAt,
      recordId: recordId,
      createdAt: createdAt,
    );
  }
}

/// 从 DailyPlan (Domain Entity) 转换为 DailyPlanData (Drift)
extension DailyPlanEntityToData on DailyPlan {
  DailyPlanData toData() {
    return DailyPlanData(
      id: id,
      planDate: planDate,
      habitId: habitId,
      cueTask: cueTask,
      scheduledTime: scheduledTime,
      priority: priority,
      isCompleted: isCompleted,
      completedAt: completedAt,
      recordId: recordId,
      createdAt: createdAt,
    );
  }

  /// 转换为 DailyPlansCompanion（用于插入/更新）
  DailyPlansCompanion toCompanion() {
    return DailyPlansCompanion.insert(
      id: id,
      planDate: planDate,
      habitId: habitId,
      cueTask: cueTask,
      scheduledTime: scheduledTime != null ? Value(scheduledTime) : const Value(null),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      completedAt: completedAt != null ? Value(completedAt) : const Value(null),
      recordId: recordId != null ? Value(recordId) : const Value(null),
      createdAt: createdAt,
    );
  }
}
