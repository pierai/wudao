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
  source:
      $enumDecodeNullable(_$RecordSourceEnumMap, json['source']) ??
      RecordSource.fromList,
  planId: json['planId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$HabitRecordToJson(_HabitRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habitId': instance.habitId,
      'executedAt': instance.executedAt.toIso8601String(),
      'quality': ?instance.quality,
      'notes': ?instance.notes,
      'isBackfilled': instance.isBackfilled,
      'source': _$RecordSourceEnumMap[instance.source]!,
      'planId': ?instance.planId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': ?instance.updatedAt?.toIso8601String(),
    };

const _$RecordSourceEnumMap = {
  RecordSource.fromPlan: 'fromPlan',
  RecordSource.fromList: 'fromList',
};
