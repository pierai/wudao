import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_result.freezed.dart';

/// 导入结果
@freezed
sealed class ImportResult with _$ImportResult {
  const factory ImportResult({
    /// 成功导入的数量
    @Default(0) int successCount,

    /// 跳过的数量（无变化）
    @Default(0) int skippedCount,

    /// 合并的数量（冲突已解决）
    @Default(0) int mergedCount,

    /// 失败的数量
    @Default(0) int failedCount,

    /// 失败详情
    @Default([]) List<String> errors,

    /// 导入耗时（毫秒）
    @Default(0) int durationMs,
  }) = _ImportResult;

  const ImportResult._();

  /// 总处理数量
  int get totalCount => successCount + skippedCount + mergedCount + failedCount;

  /// 是否成功（无失败）
  bool get isSuccess => failedCount == 0;

  /// 是否有警告（有跳过或合并）
  bool get hasWarnings => skippedCount > 0 || mergedCount > 0;

  /// 总结信息
  String get summary {
    final parts = <String>[];

    if (successCount > 0) {
      parts.add('✅ 成功导入 $successCount 项');
    }

    if (mergedCount > 0) {
      parts.add('⚠️ 合并 $mergedCount 项');
    }

    if (skippedCount > 0) {
      parts.add('⏭️ 跳过 $skippedCount 项');
    }

    if (failedCount > 0) {
      parts.add('❌ 失败 $failedCount 项');
    }

    if (parts.isEmpty) {
      return '无数据导入';
    }

    return parts.join('，');
  }

  /// 详细信息（包含错误）
  String get detailSummary {
    final buffer = StringBuffer(summary);

    if (errors.isNotEmpty) {
      buffer.write('\n\n错误详情：\n');
      for (var i = 0; i < errors.length; i++) {
        buffer.write('${i + 1}. ${errors[i]}\n');
      }
    }

    buffer.write('\n耗时：${durationMs}ms');

    return buffer.toString();
  }
}
