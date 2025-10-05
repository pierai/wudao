// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_frontmatter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitFrontmatter _$HabitFrontmatterFromJson(Map<String, dynamic> json) =>
    _HabitFrontmatter(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HabitFrontmatterToJson(_HabitFrontmatter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': ?instance.metadata,
    };
