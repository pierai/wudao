import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_level.dart';
import '../../domain/entities/goal_status.dart';

/// Goal 数据模型转换器

/// 从 GoalData (Drift) 转换为 Goal (Domain Entity)
extension GoalDataToEntity on GoalData {
  Goal toEntity() {
    return Goal(
      id: id,
      title: title,
      description: description,
      level: GoalLevel.fromValue(level),
      parentId: parentId,
      path: path,
      status: GoalStatus.fromValue(status),
      priority: priority,
      progress: progress,
      startDate: startDate,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      archivedAt: archivedAt,
    );
  }
}

/// 从 Goal (Domain Entity) 转换为 GoalData (Drift)
extension GoalEntityToData on Goal {
  GoalData toData() {
    return GoalData(
      id: id,
      title: title,
      description: description,
      level: level.value,
      parentId: parentId,
      path: path,
      status: status.value,
      priority: priority,
      progress: progress,
      startDate: startDate,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      archivedAt: archivedAt,
    );
  }

  /// 转换为 GoalsCompanion（用于插入/更新）
  GoalsCompanion toCompanion() {
    return GoalsCompanion.insert(
      id: id,
      title: title,
      description: description != null ? Value(description) : const Value(null),
      level: level.value,
      parentId: parentId != null ? Value(parentId) : const Value(null),
      path: path,
      status: Value(status.value),
      priority: Value(priority),
      progress: Value(progress),
      startDate: startDate != null ? Value(startDate) : const Value(null),
      deadline: deadline != null ? Value(deadline) : const Value(null),
      createdAt: createdAt,
      updatedAt: updatedAt != null ? Value(updatedAt) : const Value(null),
      completedAt: completedAt != null ? Value(completedAt) : const Value(null),
      archivedAt: archivedAt != null ? Value(archivedAt) : const Value(null),
    );
  }
}
