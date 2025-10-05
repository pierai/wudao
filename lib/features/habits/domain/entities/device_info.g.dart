// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => _DeviceInfo(
  deviceType: json['deviceType'] as String,
  deviceModel: json['deviceModel'] as String,
  osVersion: json['osVersion'] as String,
);

Map<String, dynamic> _$DeviceInfoToJson(_DeviceInfo instance) =>
    <String, dynamic>{
      'deviceType': instance.deviceType,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
    };
