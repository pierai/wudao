import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/habit.dart';

/// Habit 数据模型转换器
///
/// 提供 Drift Data 类与 Domain Entity 之间的转换

/// 从 HabitData (Drift) 转换为 Habit (Domain Entity)
extension HabitDataToEntity on HabitData {
  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      cue: cue,
      routine: routine,
      oldRoutine: oldRoutine,
      reward: reward,
      type: type == 'POSITIVE' ? HabitType.positive : HabitType.replacement,
      category: category,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

/// 从 Habit (Domain Entity) 转换为 HabitData (Drift)
extension HabitEntityToData on Habit {
  HabitData toData() {
    return HabitData(
      id: id,
      name: name,
      cue: cue,
      routine: routine,
      oldRoutine: oldRoutine,
      reward: reward,
      type: typeString,
      category: category,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// 转换为 HabitsCompanion（用于插入/更新）
  HabitsCompanion toCompanion() {
    return HabitsCompanion.insert(
      id: id,
      name: name,
      cue: cue,
      routine: routine,
      oldRoutine: oldRoutine != null ? Value(oldRoutine) : const Value(null),
      reward: reward,
      type: typeString,
      category: category != null ? Value(category) : const Value(null),
      notes: notes != null ? Value(notes) : const Value(null),
      isActive: Value(isActive),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt != null ? Value(deletedAt) : const Value(null),
    );
  }
}
