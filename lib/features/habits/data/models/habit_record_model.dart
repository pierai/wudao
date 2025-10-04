import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/habit_record.dart';

/// HabitRecord 数据模型转换器

/// 从 HabitRecordData (Drift) 转换为 HabitRecord (Domain Entity)
extension HabitRecordDataToEntity on HabitRecordData {
  HabitRecord toEntity() {
    return HabitRecord(
      id: id,
      habitId: habitId,
      executedAt: executedAt,
      quality: quality,
      notes: notes,
      isBackfilled: isBackfilled,
      createdAt: createdAt,
    );
  }
}

/// 从 HabitRecord (Domain Entity) 转换为 HabitRecordData (Drift)
extension HabitRecordEntityToData on HabitRecord {
  HabitRecordData toData() {
    return HabitRecordData(
      id: id,
      habitId: habitId,
      executedAt: executedAt,
      quality: quality,
      notes: notes,
      isBackfilled: isBackfilled,
      createdAt: createdAt,
    );
  }

  /// 转换为 HabitRecordsCompanion（用于插入/更新）
  HabitRecordsCompanion toCompanion() {
    return HabitRecordsCompanion.insert(
      id: id,
      habitId: habitId,
      executedAt: executedAt,
      quality: quality != null ? Value(quality) : const Value(null),
      notes: notes != null ? Value(notes) : const Value(null),
      isBackfilled: Value(isBackfilled),
      createdAt: createdAt,
    );
  }
}
