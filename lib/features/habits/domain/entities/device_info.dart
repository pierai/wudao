import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

/// 设备信息
@freezed
sealed class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String deviceType, // iPhone, macOS, Android, Windows
    required String deviceModel, // iPhone 15 Pro, MacBook Pro
    required String osVersion, // iOS 17.0, macOS 14.0
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
