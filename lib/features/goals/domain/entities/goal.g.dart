// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  level: $enumDecode(_$GoalLevelEnumMap, json['level']),
  parentId: json['parentId'] as String?,
  path: json['path'] as String,
  status:
      $enumDecodeNullable(_$GoalStatusEnumMap, json['status']) ??
      GoalStatus.active,
  priority: (json['priority'] as num?)?.toInt() ?? 3,
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': ?instance.description,
  'level': _$GoalLevelEnumMap[instance.level]!,
  'parentId': ?instance.parentId,
  'path': instance.path,
  'status': _$GoalStatusEnumMap[instance.status]!,
  'priority': instance.priority,
  'progress': instance.progress,
  'startDate': ?instance.startDate?.toIso8601String(),
  'deadline': ?instance.deadline?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': ?instance.updatedAt?.toIso8601String(),
  'completedAt': ?instance.completedAt?.toIso8601String(),
  'archivedAt': ?instance.archivedAt?.toIso8601String(),
};

const _$GoalLevelEnumMap = {
  GoalLevel.life: 'life',
  GoalLevel.domain: 'domain',
  GoalLevel.year: 'year',
  GoalLevel.quarter: 'quarter',
  GoalLevel.project: 'project',
};

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.completed: 'completed',
  GoalStatus.archived: 'archived',
};
