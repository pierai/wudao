import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/daily_plan.dart';
import '../../domain/entities/plan_completion_status.dart';

/// DailyPlan 数据模型转换器

/// 从 DailyPlanData (Drift) 转换为 DailyPlan (Domain Entity)
extension DailyPlanDataToEntity on DailyPlanData {
  DailyPlan toEntity() {
    final statusEnum = PlanCompletionStatusX.fromDbValue(status);

    return DailyPlan(
      id: id,
      planDate: planDate,
      habitId: habitId,
      cueTask: cueTask,
      scheduledTime: scheduledTime,
      priority: priority,
      status: statusEnum,
      cueCompletedAt: cueCompletedAt,
      checkedInAt: checkedInAt,
      recordId: recordId,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
      status: status.toDbValue(),
      cueCompletedAt: cueCompletedAt,
      checkedInAt: checkedInAt,
      recordId: recordId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      // 废弃字段 - 从新字段计算
      isCompleted: status.isCheckedIn || status.isSkipped,
      completedAt: checkedInAt,
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
      status: Value(status.toDbValue()),
      cueCompletedAt: cueCompletedAt != null ? Value(cueCompletedAt) : const Value(null),
      checkedInAt: checkedInAt != null ? Value(checkedInAt) : const Value(null),
      recordId: recordId != null ? Value(recordId) : const Value(null),
      createdAt: createdAt,
      updatedAt: updatedAt != null ? Value(updatedAt) : const Value(null),
      // 废弃字段 - 从新字段计算
      isCompleted: Value(status.isCheckedIn || status.isSkipped),
      completedAt: checkedInAt != null ? Value(checkedInAt) : const Value(null),
    );
  }
}
