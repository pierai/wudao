import 'package:freezed_annotation/freezed_annotation.dart';
import 'record_source.dart';

part 'habit_record.freezed.dart';
part 'habit_record.g.dart';

/// 习惯执行记录实体
///
/// 记录每次习惯的打卡情况
@freezed
sealed class HabitRecord with _$HabitRecord {
  const factory HabitRecord({
    /// 唯一标识符
    required String id,

    /// 关联的习惯 ID
    required String habitId,

    /// 执行时间（打卡时间）
    required DateTime executedAt,

    /// 执行质量评分（1-5 星，可选）
    int? quality,

    /// 执行笔记（可选）
    String? notes,

    /// 是否为补打卡
    required bool isBackfilled,

    /// 打卡来源(计划/列表)
    @Default(RecordSource.fromList) RecordSource source,

    /// 如果来自计划,记录计划 ID
    String? planId,

    /// 创建时间
    required DateTime createdAt,

    /// 更新时间
    DateTime? updatedAt,
  }) = _HabitRecord;

  const HabitRecord._();

  factory HabitRecord.fromJson(Map<String, dynamic> json) =>
      _$HabitRecordFromJson(json);

  /// 获取执行日期（忽略时间部分）
  DateTime get executedDate => DateTime(executedAt.year, executedAt.month, executedAt.day);

  /// 是否为今日打卡
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return executedDate == today;
  }

  /// 质量评分显示文本
  String get qualityDisplayText {
    if (quality == null) return '未评分';
    return '⭐' * quality!;
  }

  /// 质量评分等级
  String get qualityLevel {
    if (quality == null) return '未评分';
    if (quality! <= 2) return '勉强完成';
    if (quality! == 3) return '正常完成';
    if (quality! >= 4) return '超预期完成';
    return '未评分';
  }

  /// 是否来自计划
  bool get isFromPlan => source.isFromPlan;

  /// 是否来自列表
  bool get isFromList => source.isFromList;
}
