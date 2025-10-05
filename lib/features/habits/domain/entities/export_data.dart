import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit.dart';
import 'habit_record.dart';
import 'daily_plan.dart';
import 'habit_frontmatter.dart';

part 'export_data.freezed.dart';
part 'export_data.g.dart';

/// 导出数据容器
@freezed
sealed class ExportData with _$ExportData {
  const factory ExportData({
    required String version, // 导出格式版本
    required String appVersion, // 应用版本
    required DateTime exportedAt, // 导出时间
    required Map<String, dynamic> exportedFrom, // 导出来源设备信息
    required Map<String, dynamic> metadata, // 元数据（统计信息）
    required List<Map<String, dynamic>> habits, // 习惯列表（JSON 格式）
    required List<Map<String, dynamic>> records, // 打卡记录列表
    required List<Map<String, dynamic>> plans, // 计划列表
    required List<Map<String, dynamic>> frontmatters, // Frontmatter 列表
  }) = _ExportData;

  const ExportData._();

  factory ExportData.fromJson(Map<String, dynamic> json) =>
      _$ExportDataFromJson(json);

  /// 创建导出数据
  factory ExportData.create({
    required String appVersion,
    required Map<String, dynamic> deviceInfo,
    required List<Habit> habits,
    required List<HabitRecord> records,
    required List<DailyPlan> plans,
    required List<HabitFrontmatter> frontmatters,
  }) {
    final now = DateTime.now();
    return ExportData(
      version: '1.0.0',
      appVersion: appVersion,
      exportedAt: now,
      exportedFrom: deviceInfo,
      metadata: {
        'total_habits': habits.length,
        'total_records': records.length,
        'total_plans': plans.length,
        'total_frontmatters': frontmatters.length,
      },
      habits: habits.map((h) => h.toJson()).toList(),
      records: records.map((r) => r.toJson()).toList(),
      plans: plans.map((p) => p.toJson()).toList(),
      frontmatters: frontmatters.map((f) => f.toJson()).toList(),
    );
  }
}
