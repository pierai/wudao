import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/habit_frontmatter.dart';

/// HabitFrontmatter 数据模型转换器

/// 从 HabitFrontmatterData (Drift) 转换为 HabitFrontmatter (Domain Entity)
extension HabitFrontmatterDataToEntity on HabitFrontmatterData {
  HabitFrontmatter toEntity() {
    // 解析 tags JSON 字符串为 List<String>
    final tagsList = tags.isNotEmpty
        ? (jsonDecode(tags) as List).cast<String>()
        : <String>[];

    // 解析 metadata JSON 字符串为 Map
    final metadataMap = metadata != null && metadata!.isNotEmpty
        ? jsonDecode(metadata!) as Map<String, dynamic>
        : null;

    return HabitFrontmatter(
      id: id,
      title: title,
      content: content,
      tags: tagsList,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadataMap,
    );
  }
}

/// 从 HabitFrontmatter (Domain Entity) 转换为 HabitFrontmatterData (Drift)
extension HabitFrontmatterEntityToData on HabitFrontmatter {
  HabitFrontmatterData toData() {
    // 将 List<String> 转换为 JSON 字符串
    final tagsJson = jsonEncode(tags);

    // 将 Map 转换为 JSON 字符串
    final metadataJson = metadata != null ? jsonEncode(metadata) : null;

    return HabitFrontmatterData(
      id: id,
      title: title,
      content: content,
      tags: tagsJson,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadataJson,
    );
  }

  /// 转换为 HabitFrontmattersCompanion（用于插入/更新）
  HabitFrontmattersCompanion toCompanion() {
    final tagsJson = jsonEncode(tags);
    final metadataJson = metadata != null ? jsonEncode(metadata) : null;

    return HabitFrontmattersCompanion.insert(
      id: id,
      title: title,
      content: content,
      tags: Value(tagsJson),
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadataJson != null ? Value(metadataJson) : const Value(null),
    );
  }
}
