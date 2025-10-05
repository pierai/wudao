// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitRecord _$HabitRecordFromJson(Map<String, dynamic> json) => _HabitRecord(
  id: json['id'] as String,
  habitId: json['habitId'] as String,
  executedAt: DateTime.parse(json['executedAt'] as String),
  quality: (json['quality'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  isBackfilled: json['isBackfilled'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$HabitRecordToJson(_HabitRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habitId': instance.habitId,
      'executedAt': instance.executedAt.toIso8601String(),
      'quality': ?instance.quality,
      'notes': ?instance.notes,
      'isBackfilled': instance.isBackfilled,
      'createdAt': instance.createdAt.toIso8601String(),
    };
