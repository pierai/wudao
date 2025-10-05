// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyPlan _$DailyPlanFromJson(Map<String, dynamic> json) => _DailyPlan(
  id: json['id'] as String,
  planDate: DateTime.parse(json['planDate'] as String),
  habitId: json['habitId'] as String,
  cueTask: json['cueTask'] as String,
  scheduledTime: json['scheduledTime'] == null
      ? null
      : DateTime.parse(json['scheduledTime'] as String),
  priority: (json['priority'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  recordId: json['recordId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$DailyPlanToJson(_DailyPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planDate': instance.planDate.toIso8601String(),
      'habitId': instance.habitId,
      'cueTask': instance.cueTask,
      'scheduledTime': ?instance.scheduledTime?.toIso8601String(),
      'priority': instance.priority,
      'isCompleted': instance.isCompleted,
      'completedAt': ?instance.completedAt?.toIso8601String(),
      'recordId': ?instance.recordId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
