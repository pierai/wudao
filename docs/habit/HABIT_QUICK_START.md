# 习惯模块快速开始指南

## 概述

本指南帮助快速启动习惯模块开发。按照以下步骤，可以在**约 20 分钟**内搭建起可运行的 MVP 基础架构。

> **最后更新**: 2025-10-04
> **适用版本**: Flutter 3.35.5 / Riverpod 3.0 / Drift 2.20.0+
> **技术策略**: Phase 2 纯本地存储 (Drift/SQLite) + Repository 接口预留云端扩展性

---

## 架构说明

### Phase 2 技术策略：纯本地存储

习惯模块在 Phase 2 采用**纯本地 Drift/SQLite 存储**,无需后端服务器:

**为什么选择本地存储**:
- ✅ **高频写入场景**: 每日打卡操作无需网络依赖,响应即时
- ✅ **隐私保护**: 敏感的个人习惯数据完全本地化
- ✅ **离线可用**: 运动后、通勤时等离线场景无缝打卡
- ✅ **统计效率**: 连续天数、完成率等计算在本地高效完成

**扩展性设计**:
- 🔌 **Repository 接口**: 清晰分离业务逻辑与数据访问
- 🔌 **未来云端同步**: Phase 5+ 可添加 `RemoteHabitDataSource` 实现云端备份
- 🔌 **与目标模块对比**: 目标管理使用 PostgreSQL (层级结构 + 跨设备同步),习惯追踪使用本地存储(高频 + 隐私)

> **参考文档**:
> - 完整架构说明: `../../technical_architecture_zh.md` - 混合数据架构章节
> - Phase 2 任务清单: `../../PLAN.md` - Week 1-4 详细任务
> - 完整需求文档: `../habit_module_requirements.md`

---

## 第一步：安装依赖 (5分钟)

### 1.1 更新 pubspec.yaml

在项目根目录的 `pubspec.yaml` 文件中添加以下依赖：

> ⚠️ **版本说明**: 以下版本基于 2025-10-04 最新稳定版本,与 `CLAUDE.md` 保持一致

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 现有依赖保持不变

  # 新增依赖
  flutter_riverpod: ^3.0.0          # 状态管理 (已更新到 3.0)
  drift: ^2.20.0                     # 本地数据库 ORM (已更新)
  drift_flutter: ^0.2.0              # Drift Flutter 集成
  sqlite3_flutter_libs: ^0.5.20     # SQLite 原生库
  freezed_annotation: ^2.4.6        # 不可变数据类注解
  json_annotation: ^4.8.1           # JSON 序列化注解
  uuid: ^4.3.3                      # UUID 生成器
  flutter_markdown: ^0.7.0          # Markdown 渲染 (Frontmatter 功能)

dev_dependencies:
  flutter_test:
    sdk: flutter

  # 现有dev依赖保持不变

  # 新增dev依赖
  build_runner: ^2.4.7              # 代码生成器
  drift_dev: ^2.20.0                # Drift 代码生成 (已更新)
  riverpod_generator: ^3.0.0        # Riverpod 代码生成 (已更新到 3.0)
  freezed: ^2.4.6                   # Freezed 代码生成
  json_serializable: ^6.7.1         # JSON 序列化代码生成
```

### 1.2 运行命令

```bash
flutter pub get
```

---

## 第二步：创建数据库基础结构 (20分钟)

### 2.1 创建目录结构

```bash
mkdir -p lib/core/database/tables
mkdir -p lib/core/database/daos
```

### 2.2 创建表定义文件

**文件1**: `lib/core/database/tables/habits_table.dart`

```dart
import 'package:drift/drift.dart';

@DataClassName('HabitData')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get cue => text()();
  TextColumn get routine => text()();
  TextColumn get oldRoutine => text().nullable()();
  TextColumn get reward => text()();
  TextColumn get type => text().check(type.isIn(['POSITIVE', 'REPLACEMENT']))();
  TextColumn get category => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**文件2**: `lib/core/database/tables/habit_records_table.dart`

```dart
import 'package:drift/drift.dart';
import 'habits_table.dart';

@DataClassName('HabitRecordData')
class HabitRecords extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get executedAt => dateTime()();
  IntColumn get quality => integer().nullable().check(quality.isBetweenValues(1, 5))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isBackfilled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**文件3**: `lib/core/database/tables/daily_plans_table.dart`

```dart
import 'package:drift/drift.dart';
import 'habits_table.dart';
import 'habit_records_table.dart';

@DataClassName('DailyPlanData')
class DailyPlans extends Table {
  TextColumn get id => text()();
  DateTimeColumn get planDate => dateTime()();
  TextColumn get habitId => text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get cueTask => text()();
  DateTimeColumn get scheduledTime => dateTime().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get recordId => text().nullable().references(HabitRecords, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**文件4**: `lib/core/database/tables/habit_frontmatters_table.dart`

```dart
import 'package:drift/drift.dart';

@DataClassName('HabitFrontmatterData')
class HabitFrontmatters extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get tags => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2.3 创建DAO（简化版，先实现基本功能）

**文件**: `lib/core/database/daos/habit_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habits_table.dart';

part 'habit_dao.g.dart';

@DriftAccessor(tables: [Habits])
class HabitDao extends DatabaseAccessor<AppDatabase> with _$HabitDaoMixin {
  HabitDao(AppDatabase db) : super(db);

  Stream<List<HabitData>> watchActiveHabits() {
    return (select(habits)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<HabitData?> getHabitById(String id) {
    return (select(habits)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertHabit(HabitData habit) {
    return into(habits).insert(habit);
  }

  Future<bool> updateHabit(HabitData habit) {
    return update(habits).replace(habit);
  }

  Future<int> softDeleteHabit(String id) {
    return (update(habits)..where((tbl) => tbl.id.equals(id)))
        .write(HabitsCompanion(deletedAt: Value(DateTime.now())));
  }
}
```

**文件**: `lib/core/database/daos/habit_record_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habit_records_table.dart';

part 'habit_record_dao.g.dart';

@DriftAccessor(tables: [HabitRecords])
class HabitRecordDao extends DatabaseAccessor<AppDatabase> with _$HabitRecordDaoMixin {
  HabitRecordDao(AppDatabase db) : super(db);

  Future<List<HabitRecordData>> getRecordsByHabitId(String habitId) {
    return (select(habitRecords)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .get();
  }

  Stream<List<HabitRecordData>> watchRecordsByHabitId(String habitId) {
    return (select(habitRecords)
          ..where((tbl) => tbl.habitId.equals(habitId))
          ..orderBy([(t) => OrderingTerm.desc(t.executedAt)]))
        .watch();
  }

  Future<int> insertRecord(HabitRecordData record) {
    return into(habitRecords).insert(record);
  }

  Future<bool> hasRecordOnDate(String habitId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final count = await (selectOnly(habitRecords)
          ..addColumns([habitRecords.id.count()])
          ..where(habitRecords.habitId.equals(habitId) &
              habitRecords.executedAt.isBiggerOrEqualValue(startOfDay) &
              habitRecords.executedAt.isSmallerThanValue(endOfDay)))
        .getSingle();
    
    return count.read(habitRecords.id.count())! > 0;
  }
}
```

**文件**: `lib/core/database/daos/daily_plan_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/daily_plans_table.dart';

part 'daily_plan_dao.g.dart';

@DriftAccessor(tables: [DailyPlans])
class DailyPlanDao extends DatabaseAccessor<AppDatabase> with _$DailyPlanDaoMixin {
  DailyPlanDao(AppDatabase db) : super(db);

  Stream<List<DailyPlanData>> watchPlansByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (select(dailyPlans)
          ..where((tbl) =>
              tbl.planDate.isBiggerOrEqualValue(startOfDay) &
              tbl.planDate.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.priority)]))
        .watch();
  }

  Future<int> insertPlan(DailyPlanData plan) {
    return into(dailyPlans).insert(plan);
  }

  Future<void> insertPlans(List<DailyPlanData> plans) async {
    await batch((batch) {
      batch.insertAll(dailyPlans, plans);
    });
  }
}
```

**文件**: `lib/core/database/daos/frontmatter_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/habit_frontmatters_table.dart';

part 'frontmatter_dao.g.dart';

@DriftAccessor(tables: [HabitFrontmatters])
class FrontmatterDao extends DatabaseAccessor<AppDatabase> with _$FrontmatterDaoMixin {
  FrontmatterDao(AppDatabase db) : super(db);

  Stream<List<HabitFrontmatterData>> watchAllFrontmatters() {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<HabitFrontmatterData?> getLatestFrontmatter() {
    return (select(habitFrontmatters)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertFrontmatter(HabitFrontmatterData frontmatter) {
    return into(habitFrontmatters).insert(frontmatter);
  }

  Future<bool> updateFrontmatter(HabitFrontmatterData frontmatter) {
    return update(habitFrontmatters).replace(frontmatter);
  }
}
```

### 2.4 创建数据库主文件

**文件**: `lib/core/database/app_database.dart`

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/habits_table.dart';
import 'tables/habit_records_table.dart';
import 'tables/daily_plans_table.dart';
import 'tables/habit_frontmatters_table.dart';
import 'daos/habit_dao.dart';
import 'daos/habit_record_dao.dart';
import 'daos/daily_plan_dao.dart';
import 'daos/frontmatter_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Habits,
    HabitRecords,
    DailyPlans,
    HabitFrontmatters,
  ],
  daos: [
    HabitDao,
    HabitRecordDao,
    DailyPlanDao,
    FrontmatterDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wudao_db');
  }
}
```

### 2.5 运行代码生成

```bash
dart run build_runner build --delete-conflicting-outputs
```

**注意**：首次运行可能需要几分钟时间。

---

## 第三步：创建领域层 (15分钟)

### 3.1 创建目录结构

```bash
mkdir -p lib/features/habits/domain/entities
mkdir -p lib/features/habits/domain/repositories
```

### 3.2 创建实体

**文件**: `lib/features/habits/domain/entities/habit.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String name,
    required String cue,
    required String routine,
    String? oldRoutine,
    required String reward,
    required HabitType type,
    String? category,
    String? notes,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Habit;
}

enum HabitType {
  positive,
  replacement,
}

extension HabitX on Habit {
  String get typeString => type == HabitType.positive ? 'POSITIVE' : 'REPLACEMENT';
}
```

**文件**: `lib/features/habits/domain/entities/habit_record.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_record.freezed.dart';

@freezed
class HabitRecord with _$HabitRecord {
  const factory HabitRecord({
    required String id,
    required String habitId,
    required DateTime executedAt,
    int? quality,
    String? notes,
    required bool isBackfilled,
    required DateTime createdAt,
  }) = _HabitRecord;
}
```

**文件**: `lib/features/habits/domain/entities/habit_stats.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_stats.freezed.dart';

@freezed
class HabitStats with _$HabitStats {
  const factory HabitStats({
    required int currentStreak,
    required int totalExecutions,
    required int thisWeekExecutions,
    required double completionRate,
  }) = _HabitStats;
}
```

### 3.3 运行Freezed代码生成

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 第四步：创建数据层 (15分钟)

### 4.1 创建目录结构

```bash
mkdir -p lib/features/habits/data/models
mkdir -p lib/features/habits/data/repositories
```

### 4.2 创建模型转换器

**文件**: `lib/features/habits/data/models/habit_model.dart`

```dart
import 'package:wudao/core/database/app_database.dart';
import 'package:drift/drift.dart';
import '../../domain/entities/habit.dart';

extension HabitDataToEntity on HabitData {
  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      cue: cue,
      routine: routine,
      oldRoutine: oldRoutine,
      reward: reward,
      type: type == 'POSITIVE' ? HabitType.positive : HabitType.replacement,
      category: category,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension HabitEntityToData on Habit {
  HabitData toData() {
    return HabitData(
      id: id,
      name: name,
      cue: cue,
      routine: routine,
      oldRoutine: oldRoutine,
      reward: reward,
      type: typeString,
      category: category,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
```

**文件**: `lib/features/habits/data/models/habit_record_model.dart`

```dart
import 'package:wudao/core/database/app_database.dart';
import '../../domain/entities/habit_record.dart';

extension HabitRecordDataToEntity on HabitRecordData {
  HabitRecord toEntity() {
    return HabitRecord(
      id: id,
      habitId: habitId,
      executedAt: executedAt,
      quality: quality,
      notes: notes,
      isBackfilled: isBackfilled,
      createdAt: createdAt,
    );
  }
}

extension HabitRecordEntityToData on HabitRecord {
  HabitRecordData toData() {
    return HabitRecordData(
      id: id,
      habitId: habitId,
      executedAt: executedAt,
      quality: quality,
      notes: notes,
      isBackfilled: isBackfilled,
      createdAt: createdAt,
    );
  }
}
```

### 4.3 创建仓库接口（简化版）

**文件**: `lib/features/habits/domain/repositories/habit_repository.dart`

```dart
import '../entities/habit.dart';
import '../entities/habit_record.dart';
import '../entities/habit_stats.dart';

abstract class HabitRepository {
  // 习惯管理
  Future<Habit> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Stream<List<Habit>> watchActiveHabits();
  
  // 执行记录
  Future<void> recordExecution(HabitRecord record);
  Stream<List<HabitRecord>> watchRecordsByHabitId(String habitId);
  Future<bool> hasRecordOnDate(String habitId, DateTime date);
  
  // 统计信息
  Future<HabitStats> getHabitStats(String habitId);
}
```

### 4.4 实现仓库（简化版）

**文件**: `lib/features/habits/data/repositories/habit_repository_impl.dart`

```dart
import 'package:wudao/core/database/app_database.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../../domain/entities/habit_stats.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';
import '../models/habit_record_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitDao _habitDao;
  final HabitRecordDao _recordDao;

  HabitRepositoryImpl({
    required HabitDao habitDao,
    required HabitRecordDao recordDao,
  })  : _habitDao = habitDao,
        _recordDao = recordDao;

  @override
  Future<Habit> createHabit(Habit habit) async {
    await _habitDao.insertHabit(habit.toData());
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _habitDao.updateHabit(habit.toData());
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _habitDao.softDeleteHabit(id);
  }

  @override
  Stream<List<Habit>> watchActiveHabits() {
    return _habitDao.watchActiveHabits().map(
      (list) => list.map((data) => data.toEntity()).toList(),
    );
  }

  @override
  Future<void> recordExecution(HabitRecord record) async {
    await _recordDao.insertRecord(record.toData());
  }

  @override
  Stream<List<HabitRecord>> watchRecordsByHabitId(String habitId) {
    return _recordDao.watchRecordsByHabitId(habitId).map(
      (list) => list.map((data) => data.toEntity()).toList(),
    );
  }

  @override
  Future<bool> hasRecordOnDate(String habitId, DateTime date) {
    return _recordDao.hasRecordOnDate(habitId, date);
  }

  @override
  Future<HabitStats> getHabitStats(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);
    
    return HabitStats(
      currentStreak: _calculateCurrentStreak(records),
      totalExecutions: records.length,
      thisWeekExecutions: _calculateThisWeekExecutions(records),
      completionRate: _calculateCompletionRate(records),
    );
  }

  int _calculateCurrentStreak(List<HabitRecordData> records) {
    if (records.isEmpty) return 0;
    
    records.sort((a, b) => b.executedAt.compareTo(a.executedAt));
    
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (var record in records) {
      final recordDate = DateTime(
        record.executedAt.year,
        record.executedAt.month,
        record.executedAt.day,
      );
      final checkDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      
      if (recordDate == checkDate || recordDate == checkDate.subtract(const Duration(days: 1))) {
        streak++;
        currentDate = recordDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  int _calculateThisWeekExecutions(List<HabitRecordData> records) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return records.where((record) => record.executedAt.isAfter(weekStart)).length;
  }

  double _calculateCompletionRate(List<HabitRecordData> records) {
    if (records.isEmpty) return 0.0;
    
    final firstRecord = records.reduce(
      (a, b) => a.executedAt.isBefore(b.executedAt) ? a : b,
    );
    
    final daysSinceStart = DateTime.now().difference(firstRecord.executedAt).inDays + 1;
    
    return records.length / daysSinceStart;
  }
}
```

---

## 第五步：创建表示层基础 (20分钟)

### 5.1 创建Providers

**文件**: `lib/features/habits/presentation/providers/habit_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wudao/core/database/app_database.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_stats.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../data/repositories/habit_repository_impl.dart';

// 数据库Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// 仓库Provider
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return HabitRepositoryImpl(
    habitDao: database.habitDao,
    recordDao: database.habitRecordDao,
  );
});

// 活跃习惯列表Provider
final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchActiveHabits();
});

// 习惯统计Provider
final habitStatsProvider = FutureProvider.family<HabitStats, String>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitStats(habitId);
});

// 今日是否已打卡Provider
final hasTodayRecordProvider = FutureProvider.family<bool, String>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.hasRecordOnDate(habitId, DateTime.now());
});
```

### 5.2 更新main.dart使用Riverpod

**文件**: `lib/main.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

### 5.3 更新app.dart

**文件**: `lib/app.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/screens/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CupertinoApp(
      title: 'Wudao',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

## 第六步：创建简单的习惯列表UI (20分钟)

### 6.1 更新习惯列表页面

**文件**: `lib/features/habits/presentation/screens/habits_screen.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'habit_form_screen.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('习惯追踪'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const HabitFormScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: habitsAsync.when(
          data: (habits) {
            if (habits.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.chart_bar_fill,
                      size: 80,
                      color: CupertinoColors.systemGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '还没有习惯',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '点击右上角 + 添加你的第一个习惯',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitCard(habit: habits[index]);
              },
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('错误: $error'),
          ),
        ),
      ),
    );
  }
}
```

### 6.2 创建习惯卡片组件

**文件**: `lib/features/habits/presentation/widgets/habit_card.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';
import 'check_in_dialog.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(habitStatsProvider(habit.id));
    final hasTodayRecord = ref.watch(hasTodayRecordProvider(habit.id));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  habit.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (habit.type == HabitType.replacement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '替代',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '暗示: ${habit.cue}',
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statsAsync.when(
                data: (stats) => Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${stats.currentStreak}天',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '总计 ${stats.totalExecutions}次',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                loading: () => const CupertinoActivityIndicator(),
                error: (_, __) => const SizedBox(),
              ),
              hasTodayRecord.when(
                data: (hasRecord) => CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: hasRecord
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(8),
                  child: Text(
                    hasRecord ? '已打卡 ✓' : '打卡',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: hasRecord
                      ? null
                      : () => _showCheckInDialog(context, ref),
                ),
                loading: () => const CupertinoActivityIndicator(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCheckInDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CheckInDialog(habit: habit),
    );
  }
}
```

### 6.3 创建打卡对话框

**文件**: `lib/features/habits/presentation/widgets/check_in_dialog.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_record.dart';
import '../providers/habit_provider.dart';

class CheckInDialog extends ConsumerStatefulWidget {
  final Habit habit;

  const CheckInDialog({super.key, required this.habit});

  @override
  ConsumerState<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends ConsumerState<CheckInDialog> {
  DateTime _executedAt = DateTime.now();
  int _quality = 3;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('今日打卡'),
      content: Column(
        children: [
          const SizedBox(height: 16),
          const Text('执行质量'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _quality = index + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    index < _quality ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _notesController,
            placeholder: '执行笔记（可选）',
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        CupertinoDialogAction(
          onPressed: _handleCheckIn,
          child: const Text('确认打卡'),
        ),
      ],
    );
  }

  Future<void> _handleCheckIn() async {
    final record = HabitRecord(
      id: const Uuid().v4(),
      habitId: widget.habit.id,
      executedAt: _executedAt,
      quality: _quality,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      isBackfilled: false,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(habitRepositoryProvider).recordExecution(record);

      if (mounted) {
        Navigator.pop(context);

        // 刷新Provider
        ref.invalidate(habitStatsProvider(widget.habit.id));
        ref.invalidate(hasTodayRecordProvider(widget.habit.id));

        // 显示成功提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Column(
              children: [
                Text('✓', style: TextStyle(fontSize: 48, color: CupertinoColors.systemGreen)),
                SizedBox(height: 8),
                Text('打卡成功！'),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('错误'),
            content: Text('打卡失败: $e'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }
}
```

### 6.4 创建习惯表单页面

**文件**: `lib/features/habits/presentation/screens/habit_form_screen.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';

class HabitFormScreen extends ConsumerStatefulWidget {
  final String? habitId;

  const HabitFormScreen({super.key, this.habitId});

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  final _nameController = TextEditingController();
  final _cueController = TextEditingController();
  final _routineController = TextEditingController();
  final _oldRoutineController = TextEditingController();
  final _rewardController = TextEditingController();
  final _notesController = TextEditingController();

  HabitType _selectedType = HabitType.positive;

  @override
  void dispose() {
    _nameController.dispose();
    _cueController.dispose();
    _routineController.dispose();
    _oldRoutineController.dispose();
    _rewardController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.habitId == null ? '添加习惯' : '编辑习惯'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('保存'),
          onPressed: _handleSave,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField('习惯名称', _nameController),
            const SizedBox(height: 16),
            _buildTypeSelector(),
            const SizedBox(height: 16),
            _buildTextField('暗示（触发条件）', _cueController, maxLines: 3),
            const SizedBox(height: 8),
            const Text(
              '💡 暗示越具体，越容易触发',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedType == HabitType.replacement) ...[
              _buildTextField('原惯常行为（可选）', _oldRoutineController, maxLines: 2),
              const SizedBox(height: 16),
            ],
            _buildTextField('惯常行为（要执行的动作）', _routineController, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField('奖赏（行为带来的收益）', _rewardController, maxLines: 3),
            const SizedBox(height: 8),
            const Text(
              '💡 明确奖赏有助于习惯养成',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('备注（可选）', _notesController, maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          maxLines: maxLines,
          placeholder: label,
          padding: const EdgeInsets.all(12),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '习惯类型',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoSegmentedControl<HabitType>(
          children: const {
            HabitType.positive: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('正向习惯'),
            ),
            HabitType.replacement: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('习惯替代'),
            ),
          },
          groupValue: _selectedType,
          onValueChanged: (value) {
            setState(() => _selectedType = value);
          },
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty ||
        _cueController.text.isEmpty ||
        _routineController.text.isEmpty ||
        _rewardController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('请填写所有必填项'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      return;
    }

    final habit = Habit(
      id: widget.habitId ?? const Uuid().v4(),
      name: _nameController.text,
      cue: _cueController.text,
      routine: _routineController.text,
      oldRoutine: _oldRoutineController.text.isNotEmpty ? _oldRoutineController.text : null,
      reward: _rewardController.text,
      type: _selectedType,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await ref.read(habitRepositoryProvider).createHabit(habit);
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('错误'),
            content: Text('保存失败: $e'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }
}
```

---

## 第七步：测试运行 (5分钟)

### 7.1 运行应用

```bash
flutter run
```

### 7.2 测试功能

1. 点击右上角"+"添加习惯
2. 填写习惯信息并保存
3. 在列表中查看习惯
4. 点击"打卡"按钮进行打卡
5. 观察连续天数和总次数的变化

---

## 成功标志

完成以上步骤后，你应该能够：

✅ 创建新习惯（正向习惯和习惯替代）
✅ 查看习惯列表
✅ 对习惯进行打卡
✅ 查看连续天数和总执行次数
✅ 看到已打卡的习惯显示"已打卡 ✓"

---

## 下一步计划

基础功能已经可以运行，接下来可以实现：

1. **习惯详情页** - 显示更详细的统计信息和历史记录
2. **日历热力图** - 可视化展示打卡历史
3. **次日计划功能** - 生成和管理次日计划
4. **Frontmatter功能** - 记录习惯感悟
5. **UI优化** - 添加动画、更好的交互反馈

---

## 常见问题

### Q: 代码生成失败？
**A**: 确保所有导入路径正确，然后运行：
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Q: 数据库无法创建？
**A**: 检查 `sqlite3_flutter_libs` 是否正确安装。在iOS模拟器上可能需要重新编译。

### Q: Provider状态不更新？
**A**: 确保使用 `ConsumerWidget` 或 `ConsumerStatefulWidget`，并在需要刷新时调用 `ref.invalidate()`。

### Q: 打卡后列表不刷新？
**A**: 在打卡成功后调用：
```dart
ref.invalidate(habitStatsProvider(habitId));
ref.invalidate(hasTodayRecordProvider(habitId));
```

---

## 资源链接

- [Drift文档](https://drift.simonbinder.eu/)
- [Riverpod文档](https://riverpod.dev/)
- [Freezed文档](https://pub.dev/packages/freezed)
- [Flutter Cupertino组件](https://docs.flutter.dev/ui/widgets/cupertino)

---

## 版本更新说明

### v2.0 (2025-10-04)

**重大更新**:
- ✅ 依赖升级至最新版本 (Riverpod 3.0, Drift 2.20.0+)
- ✅ 明确 Phase 2 纯本地存储策略
- ✅ 强调 Repository 接口设计的未来扩展性
- ✅ 添加架构说明章节

**技术栈变化**:
| 依赖 | 旧版本 | 新版本 | 说明 |
|------|-------|--------|------|
| flutter_riverpod | ^2.5.1 | ^3.0.0 | 状态管理升级 |
| drift | ^2.16.0 | ^2.20.0 | 数据库 ORM 升级 |
| riverpod_generator | ^2.4.0 | ^3.0.0 | 代码生成器升级 |
| flutter_markdown | ^0.6.20 | ^0.7.0 | Markdown 渲染升级 |

**架构说明**:
- Phase 2 采用纯本地 Drift/SQLite 存储
- Repository 模式设计,为 Phase 5+ 云端同步预留扩展性
- 与目标模块的混合数据架构策略一致

---

现在你已经有了一个可运行的习惯追踪模块的基础版本！🎉

**下一步**:
1. 查看 `../../PLAN.md` Phase 2 完整开发计划
2. 阅读 `../habit_module_requirements.md` 了解详细设计
3. 参考 `../../technical_architecture_zh.md` 理解架构决策
