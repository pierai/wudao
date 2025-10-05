// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportData _$ExportDataFromJson(Map<String, dynamic> json) => _ExportData(
  version: json['version'] as String,
  appVersion: json['appVersion'] as String,
  exportedAt: DateTime.parse(json['exportedAt'] as String),
  exportedFrom: json['exportedFrom'] as Map<String, dynamic>,
  metadata: json['metadata'] as Map<String, dynamic>,
  habits: (json['habits'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  records: (json['records'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  plans: (json['plans'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  frontmatters: (json['frontmatters'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$ExportDataToJson(_ExportData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'appVersion': instance.appVersion,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'exportedFrom': instance.exportedFrom,
      'metadata': instance.metadata,
      'habits': instance.habits,
      'records': instance.records,
      'plans': instance.plans,
      'frontmatters': instance.frontmatters,
    };
