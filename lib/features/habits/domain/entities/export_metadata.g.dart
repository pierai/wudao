// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportMetadata _$ExportMetadataFromJson(Map<String, dynamic> json) =>
    _ExportMetadata(
      version: json['version'] as String,
      appVersion: json['appVersion'] as String,
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      exportedFrom: DeviceInfo.fromJson(
        json['exportedFrom'] as Map<String, dynamic>,
      ),
      totalHabits: (json['totalHabits'] as num).toInt(),
      totalRecords: (json['totalRecords'] as num).toInt(),
      totalPlans: (json['totalPlans'] as num).toInt(),
      totalFrontmatters: (json['totalFrontmatters'] as num).toInt(),
    );

Map<String, dynamic> _$ExportMetadataToJson(_ExportMetadata instance) =>
    <String, dynamic>{
      'version': instance.version,
      'appVersion': instance.appVersion,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'exportedFrom': instance.exportedFrom.toJson(),
      'totalHabits': instance.totalHabits,
      'totalRecords': instance.totalRecords,
      'totalPlans': instance.totalPlans,
      'totalFrontmatters': instance.totalFrontmatters,
    };
