// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Habit _$HabitFromJson(Map<String, dynamic> json) => _Habit(
  id: json['id'] as String,
  name: json['name'] as String,
  cue: json['cue'] as String?,
  routine: json['routine'] as String,
  oldRoutine: json['oldRoutine'] as String?,
  reward: json['reward'] as String?,
  type: $enumDecode(_$HabitTypeEnumMap, json['type']),
  category: json['category'] as String?,
  notes: json['notes'] as String?,
  isActive: json['isActive'] as bool,
  isKeystone: json['isKeystone'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$HabitToJson(_Habit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cue': ?instance.cue,
  'routine': instance.routine,
  'oldRoutine': ?instance.oldRoutine,
  'reward': ?instance.reward,
  'type': _$HabitTypeEnumMap[instance.type]!,
  'category': ?instance.category,
  'notes': ?instance.notes,
  'isActive': instance.isActive,
  'isKeystone': instance.isKeystone,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': ?instance.deletedAt?.toIso8601String(),
};

const _$HabitTypeEnumMap = {
  HabitType.positive: 'positive',
  HabitType.replacement: 'replacement',
};
