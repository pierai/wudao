import 'package:freezed_annotation/freezed_annotation.dart';
import 'device_info.dart';

part 'export_metadata.freezed.dart';
part 'export_metadata.g.dart';

/// 导出元数据
@freezed
sealed class ExportMetadata with _$ExportMetadata {
  const factory ExportMetadata({
    required String version, // 导出格式版本，如 "1.0.0"
    required String appVersion, // 应用版本，如 "0.1.0"
    required DateTime exportedAt, // 导出时间
    required DeviceInfo exportedFrom, // 导出来源设备
    required int totalHabits, // 习惯总数
    required int totalRecords, // 打卡记录总数
    required int totalPlans, // 计划总数
    required int totalFrontmatters, // Frontmatter 总数
  }) = _ExportMetadata;

  const ExportMetadata._();

  factory ExportMetadata.fromJson(Map<String, dynamic> json) =>
      _$ExportMetadataFromJson(json);

  /// 当前导出格式版本
  static const String currentVersion = '1.0.0';
}
