import 'package:drift/drift.dart';
import 'habits_table.dart';
import 'habit_records_table.dart';

/// 次日计划表 - 将习惯的"暗示"转化为次日行动计划
///
/// 基于《习惯的力量》理论：明确的暗示有助于触发习惯行为
@DataClassName('DailyPlanData')
class DailyPlans extends Table {
  /// 唯一标识符（UUID）
  TextColumn get id => text()();

  /// 计划日期（日期部分，时间部分为 00:00:00）
  DateTimeColumn get planDate => dateTime()();

  /// 关联的习惯 ID（外键，级联删除）
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();

  /// 暗示任务：基于习惯的 cue 生成的具体任务描述
  /// 示例：习惯 cue="早上起床后看到书包" -> cueTask="起床后将书包放在显眼位置"
  TextColumn get cueTask => text().withLength(min: 1, max: 500)();

  /// 计划执行时间（可选）
  /// 用户可以指定计划在某个具体时间执行
  DateTimeColumn get scheduledTime => dateTime().nullable()();

  /// 优先级（0-10，数字越小优先级越高，默认 0）
  IntColumn get priority => integer().withDefault(const Constant(0))();

  /// 计划完成状态（pending/cueCompleted/checkedIn/skipped）
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();

  /// 暗示完成时间
  DateTimeColumn get cueCompletedAt => dateTime().nullable()();

  /// 打卡时间
  DateTimeColumn get checkedInAt => dateTime().nullable()();

  /// 关联的打卡记录 ID（外键，可选）
  /// 当计划完成时，创建 HabitRecord 并关联
  /// onDelete: setNull - 如果打卡记录被删除，不影响计划记录
  TextColumn get recordId => text()
      .nullable()
      .references(HabitRecords, #id, onDelete: KeyAction.setNull)();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // ==================== 提醒功能字段 ====================
  /// 是否启用提醒（默认启用）
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();

  /// 提前提醒分钟数（0=准时, 5=提前5分钟, 10=提前10分钟, 15=提前15分钟，默认0）
  IntColumn get reminderMinutesBefore => integer().withDefault(const Constant(0))();

  // ==================== 废弃字段(向后兼容) ====================
  /// @deprecated 使用 status 替代
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// @deprecated 使用 checkedInAt 替代
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
