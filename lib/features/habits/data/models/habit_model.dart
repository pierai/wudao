import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_category.dart';

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
      type: HabitTypeX.fromString(type),
      category: category != null ? HabitCategoryX.fromString(category!) : null,
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
      category: category?.toDbString(),
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
      cue: cue != null ? Value(cue) : const Value(null),
      routine: routine,
      oldRoutine: oldRoutine != null ? Value(oldRoutine) : const Value(null),
      reward: reward != null ? Value(reward) : const Value(null),
      type: typeString,
      category: category != null
          ? Value(category!.toDbString())
          : const Value(null),
      notes: notes != null ? Value(notes) : const Value(null),
      isActive: Value(isActive),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt != null ? Value(deletedAt) : const Value(null),
    );
  }
}
