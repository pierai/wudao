import 'package:freezed_annotation/freezed_annotation.dart';
import 'goal_level.dart';
import 'goal_status.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

/// 目标实体
///
/// 基于《高效能人士的七个习惯》第二习惯"以终为始"设计的层级目标系统
/// 支持 5 层目标层级：人生目标 → 领域目标 → 年度目标 → 季度目标 → 项目目标
@freezed
sealed class Goal with _$Goal {
  const factory Goal({
    /// 唯一标识符
    required String id,

    /// 目标标题
    required String title,

    /// 目标描述
    String? description,

    /// 目标层级
    required GoalLevel level,

    /// 父目标 ID（人生目标的 parentId 为 null）
    String? parentId,

    /// 层级路径（ltree 格式，如 "life.1.2025.q1"）
    /// 用于高效查询子树和祖先
    required String path,

    /// 目标状态
    @Default(GoalStatus.active) GoalStatus status,

    /// 优先级（1-5，1 最高，5 最低）
    @Default(3) int priority,

    /// 进度百分比（0-100）
    @Default(0) int progress,

    /// 开始日期
    DateTime? startDate,

    /// 截止日期
    DateTime? deadline,

    /// 创建时间
    required DateTime createdAt,

    /// 更新时间
    DateTime? updatedAt,

    /// 完成时间
    DateTime? completedAt,

    /// 归档时间
    DateTime? archivedAt,
  }) = _Goal;

  const Goal._();

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  /// 是否为根目标（人生目标）
  bool get isRoot => parentId == null && level == GoalLevel.life;

  /// 是否为叶子目标（项目目标）
  bool get isLeaf => level == GoalLevel.project;

  /// 是否活跃
  bool get isActive => status == GoalStatus.active;

  /// 是否已完成
  bool get isCompleted => status == GoalStatus.completed;

  /// 是否已归档
  bool get isArchived => status == GoalStatus.archived;

  /// 是否逾期（有截止日期且未完成）
  bool get isOverdue {
    if (deadline == null || isCompleted) return false;
    return DateTime.now().isAfter(deadline!);
  }

  /// 进度显示文本
  String get progressDisplayText {
    if (progress == 0) return '未开始';
    if (progress == 100) return '已完成';
    return '$progress%';
  }

  /// 优先级显示文本
  String get priorityDisplayText {
    switch (priority) {
      case 1:
        return '最高';
      case 2:
        return '高';
      case 3:
        return '中';
      case 4:
        return '低';
      case 5:
        return '最低';
      default:
        return '中';
    }
  }

  /// 层级深度（从 path 计算）
  int get depth => path.split('.').length;

  /// 获取父路径
  String? get parentPath {
    final parts = path.split('.');
    if (parts.length <= 1) return null;
    return parts.sublist(0, parts.length - 1).join('.');
  }

  /// 生成子目标路径
  String childPath(String childId) => '$path.$childId';
}
