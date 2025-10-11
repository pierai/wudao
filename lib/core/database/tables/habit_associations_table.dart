import 'package:drift/drift.dart';

/// 习惯关联表 - 用于记录核心习惯与伴随习惯的关系
///
/// 核心习惯（Keystone Habit）能引发连锁反应，带动其他习惯的形成。
/// 例如：运动（核心习惯）→ 健康饮食 + 良好睡眠 + 提高效率（伴随习惯）
@DataClassName('HabitAssociationData')
class HabitAssociations extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 核心习惯ID（必须是 isKeystone = true 的习惯）
  TextColumn get keystoneHabitId => text()();

  /// 关联的普通习惯ID（伴随习惯）
  TextColumn get associatedHabitId => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    // 外键约束：核心习惯必须存在
    'FOREIGN KEY (keystone_habit_id) REFERENCES habits(id) ON DELETE CASCADE',
    // 外键约束：关联习惯必须存在
    'FOREIGN KEY (associated_habit_id) REFERENCES habits(id) ON DELETE CASCADE',
    // 唯一约束：同一对习惯只能关联一次
    'UNIQUE (keystone_habit_id, associated_habit_id)',
  ];
}
