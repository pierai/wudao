import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_frontmatter.freezed.dart';
part 'habit_frontmatter.g.dart';

/// 习惯 Frontmatter 实体
///
/// 记录习惯相关的感悟和笔记（Markdown 格式）
@freezed
sealed class HabitFrontmatter with _$HabitFrontmatter {
  const factory HabitFrontmatter({
    /// 唯一标识符
    required String id,

    /// 标题
    required String title,

    /// Markdown 内容
    required String content,

    /// 标签列表
    required List<String> tags,

    /// 创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 元数据（可选）
    Map<String, dynamic>? metadata,
  }) = _HabitFrontmatter;

  const HabitFrontmatter._();

  factory HabitFrontmatter.fromJson(Map<String, dynamic> json) =>
      _$HabitFrontmatterFromJson(json);

  /// 是否包含指定标签
  bool hasTag(String tag) => tags.contains(tag);

  /// 添加标签（返回新的实例）
  HabitFrontmatter addTag(String tag) {
    if (hasTag(tag)) return this;
    return copyWith(tags: [...tags, tag]);
  }

  /// 移除标签（返回新的实例）
  HabitFrontmatter removeTag(String tag) {
    if (!hasTag(tag)) return this;
    return copyWith(tags: tags.where((t) => t != tag).toList());
  }

  /// 获取元数据中的值
  T? getMetadata<T>(String key) {
    if (metadata == null) return null;
    return metadata![key] as T?;
  }

  /// 设置元数据（返回新的实例）
  HabitFrontmatter setMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata ?? {});
    newMetadata[key] = value;
    return copyWith(metadata: newMetadata);
  }

  /// 内容预览（前100个字符）
  String get contentPreview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }
}
