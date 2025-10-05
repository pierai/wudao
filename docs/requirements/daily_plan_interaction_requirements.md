# 次日计划交互优化需求文档

## 文档信息

- **版本**: v1.0.0
- **创建日期**: 2025-10-05
- **负责人**: @flutter_architect
- **状态**: 待实现

## 1. 背景和问题

### 1.1 当前问题

当前次日计划功能存在以下问题:

1. **暗示完成和习惯打卡的边界不清晰**
   - "仅标记完成"和"完成并打卡"都调用同一个方法,无法区分状态
   - 缺少 `recordId` 关联,无法追踪是否已打卡
   - 用户在习惯列表直接打卡后,次日计划状态未同步

2. **交互流程不直观**
   - 点击卡片弹出二选一对话框,增加操作步骤
   - "仅标记完成"后无法补打卡

3. **明日计划定义模糊**
   - 明日计划是否允许操作不明确

4. **重复打卡问题**
   - 同一天可能在计划和习惯列表重复打卡

### 1.2 核心理念

基于《习惯的力量》理论:

```
习惯循环 = 暗示(Cue) → 惯常行为(Routine) → 奖赏(Reward)
```

**次日计划的核心作用**:
- 帮助用户**提前规划暗示**,强化触发机制
- 完成暗示 ≠ 完成习惯,暗示只是触发信号
- 打卡才是记录惯常行为的执行

## 2. 需求目标

### 2.1 核心目标

1. **明确状态边界**: 暗示完成、已打卡、已跳过三种状态清晰可区分
2. **优化交互流程**: 减少操作步骤,提供直观的补打卡入口
3. **数据同步**: 习惯列表和次日计划状态自动同步
4. **防止重复打卡**: 同一天只能打卡一次

### 2.2 用户场景

#### 场景 1: 按计划完整执行习惯循环

```
用户查看今日计划
→ 点击计划卡片标记暗示完成 ✓
→ 执行惯常行为(如:去图书馆学习)
→ 点击"打卡"按钮
→ 填写打卡信息(时间、质量、笔记)
→ 提交成功
→ 习惯列表显示"已打卡"
```

#### 场景 2: 仅完成暗示,稍后补打卡

```
用户查看今日计划
→ 点击计划卡片标记暗示完成 ✓
→ 暂时没时间执行惯常行为
→ 稍后在计划卡片上点击"打卡"按钮
→ 填写打卡信息
→ 提交成功
```

#### 场景 3: 跳过计划,直接在习惯列表打卡

```
用户未查看计划
→ 直接在习惯列表点击打卡
→ 填写打卡信息
→ 提交成功
→ 今日计划自动标记为"已跳过(直接打卡)"
→ 计划卡片显示删除线样式 + "已跳过"徽章
```

#### 场景 4: 尝试重复打卡

```
用户已通过计划打卡
→ 在习惯列表再次点击打卡按钮
→ 按钮显示"已打卡"状态(禁用)
→ 弹出提示:"今日已通过次日计划打卡"
```

## 3. 功能设计

### 3.1 状态机设计

```dart
enum PlanCompletionStatus {
  pending,        // ⏳ 待执行(初始状态)
  cueCompleted,   // ✅ 暗示已完成(未打卡)
  checkedIn,      // ✅ 已打卡(通过计划打卡)
  skipped,        // ⚠️ 已跳过(在习惯列表直接打卡)
}
```

#### 状态流转规则

```
pending
  ├─→ cueCompleted (点击卡片)
  │     └─→ checkedIn (点击"打卡"按钮)
  ├─→ checkedIn (点击卡片后立即打卡,未来可选)
  └─→ skipped (在习惯列表直接打卡)

cueCompleted ←→ pending (取消完成,可逆操作)
checkedIn ←→ cueCompleted (取消打卡,可逆操作)
skipped (不可逆,仅记录状态)
```

### 3.2 数据模型修改

#### 3.2.1 DailyPlan 实体

**新增字段**:

```dart
@freezed
sealed class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required String id,
    required String habitId,
    required String cueTask,
    required DateTime date,
    required int priority,
    DateTime? scheduledTime,

    // 新增字段 ↓
    required PlanCompletionStatus status,  // 计划状态
    String? recordId,                      // 关联的打卡记录ID
    DateTime? cueCompletedAt,              // 暗示完成时间
    DateTime? checkedInAt,                 // 打卡时间
    // 新增字段 ↑

    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _DailyPlan;

  const DailyPlan._();

  // 便捷方法
  bool get isPending => status == PlanCompletionStatus.pending;
  bool get isCueCompleted => status == PlanCompletionStatus.cueCompleted;
  bool get isCheckedIn => status == PlanCompletionStatus.checkedIn;
  bool get isSkipped => status == PlanCompletionStatus.skipped;

  // 向后兼容(旧代码使用 isCompleted)
  bool get isCompleted => status == PlanCompletionStatus.checkedIn;
}
```

#### 3.2.2 DailyPlansTable (Drift)

```dart
class DailyPlansTable extends Table {
  @override
  String get tableName => 'daily_plans';

  TextColumn get id => text()();
  TextColumn get habitId => text()();
  TextColumn get cueTask => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get priority => integer().withDefault(const Constant(5))();
  DateTimeColumn get scheduledTime => dateTime().nullable()();

  // 新增字段 ↓
  TextColumn get status => text()
      .withDefault(const Constant('pending'))();  // 默认待执行
  TextColumn get recordId => text().nullable()();  // 打卡记录ID
  DateTimeColumn get cueCompletedAt => dateTime().nullable()();  // 暗示完成时间
  DateTimeColumn get checkedInAt => dateTime().nullable()();     // 打卡时间
  // 新增字段 ↑

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 3.2.3 HabitRecord 实体

**新增字段**:

```dart
@freezed
sealed class HabitRecord with _$HabitRecord {
  const factory HabitRecord({
    required String id,
    required String habitId,
    required DateTime date,
    required DateTime executedAt,
    required int quality,
    String? note,

    // 新增字段 ↓
    required RecordSource source,  // 打卡来源(计划/列表)
    String? planId,                // 如果来自计划,记录计划ID
    // 新增字段 ↑

    @Default(false) bool isBackfilled,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _HabitRecord;
}

enum RecordSource {
  fromPlan,   // 通过次日计划打卡
  fromList,   // 在习惯列表直接打卡
}
```

### 3.3 交互设计

#### 3.3.1 明日计划 Tab

**定义**: 为明天生成暗示任务(只读,不可操作)

**UI 状态**:
- 卡片置灰,透明度 0.6
- 不显示完成状态圆圈
- 点击无响应(或弹出提示:"明天才能执行此计划")
- 仅用于预览明天的计划安排

#### 3.3.2 今日计划 Tab

**定义**: 查看/执行今天生成的暗示任务(可完成、可打卡)

##### 状态 1: pending (待执行)

**卡片样式**:
```
┌────────────────────────────────────┐
│ ○  准备好书包放在椅子上              │  ← 空心圆圈
│    🔗 图书馆学习                    │
│    🕐 08:00            [高]         │
└────────────────────────────────────┘
```

**交互**:
- 点击卡片整体 → 标记暗示完成(状态 → cueCompleted)
- 无"打卡"按钮

##### 状态 2: cueCompleted (暗示已完成)

**卡片样式**:
```
┌────────────────────────────────────┐
│ ✓  准备好书包放在椅子上  [打卡]     │  ← 绿色勾 + 打卡按钮
│    🔗 图书馆学习                    │
│    🕐 08:00            [高]         │
└────────────────────────────────────┘
```

**交互**:
- 点击卡片整体 → 取消暗示完成(状态 → pending)
- 点击"打卡"按钮 → 弹出打卡对话框 → 填写信息 → 提交(状态 → checkedIn)

##### 状态 3: checkedIn (已打卡)

**卡片样式**:
```
┌────────────────────────────────────┐
│ ✓  准备好书包放在椅子上  [已打卡]   │  ← 绿色勾 + 已打卡徽章
│    🔗 图书馆学习                    │
│    🕐 08:00  ⭐⭐⭐⭐⭐  [高]       │  ← 显示质量星级
└────────────────────────────────────┘
```

**交互**:
- 点击卡片整体 → 取消打卡(状态 → cueCompleted,删除打卡记录)
- "已打卡"徽章置灰,不可点击

##### 状态 4: skipped (已跳过)

**卡片样式**:
```
┌────────────────────────────────────┐
│ ⚠️  准备好书包放在椅子上  [已跳过]  │  ← 删除线 + 灰色文字
│    🔗 图书馆学习 (已在列表打卡)     │
│    🕐 08:00            [高]         │
└────────────────────────────────────┘
```

**交互**:
- 点击无响应(状态不可逆)
- 仅记录状态,用于后续分析"暗示触发率"

#### 3.3.3 习惯列表卡片

##### 未打卡状态

```
┌────────────────────────────────────┐
│ 图书馆学习              [打卡]      │
│ 暗示: 准备好书包                   │
│ 连续 5 天 · 完成率 80%              │
└────────────────────────────────────┘
```

**交互**:
- 点击"打卡"按钮 → 弹出打卡对话框 → 提交成功 → 自动同步计划状态为 `skipped`

##### 已打卡状态

```
┌────────────────────────────────────┐
│ 图书馆学习              [已打卡]    │  ← 按钮置灰
│ 暗示: 准备好书包                   │
│ 连续 5 天 · 完成率 80%              │
│ 今日 ⭐⭐⭐⭐⭐ 10:30              │  ← 显示打卡信息
└────────────────────────────────────┘
```

**交互**:
- "已打卡"按钮禁用,点击弹出提示:"今日已打卡"

### 3.4 业务逻辑

#### 3.4.1 Repository 层新增方法

```dart
abstract class HabitRepository {
  // 更新计划状态
  Future<void> markCueCompleted(String planId);
  Future<void> markCueIncomplete(String planId);
  Future<void> markPlanCheckedIn(String planId, String recordId);
  Future<void> markPlanSkipped(String planId);

  // 取消打卡(同时取消计划关联)
  Future<void> cancelCheckIn(String recordId);

  // 检查今日是否已打卡(用于防重复)
  Future<bool> hasTodayRecord(String habitId, DateTime date);

  // 获取今日打卡记录(用于显示星级)
  Future<HabitRecord?> getTodayRecord(String habitId, DateTime date);

  // 同步计划状态(习惯列表打卡时调用)
  Future<void> syncPlanStatusAfterCheckIn(String habitId, DateTime date, String recordId);
}
```

#### 3.4.2 状态同步规则

##### 规则 1: 习惯列表打卡 → 计划状态同步

```dart
Future<void> syncPlanStatusAfterCheckIn(String habitId, DateTime date, String recordId) async {
  // 1. 查找今日该习惯的计划
  final plan = await getPlanByHabitAndDate(habitId, date);

  if (plan != null && plan.status == PlanCompletionStatus.pending) {
    // 2. 如果计划状态为 pending,标记为 skipped
    await markPlanSkipped(plan.id);
  } else if (plan != null && plan.status == PlanCompletionStatus.cueCompleted) {
    // 3. 如果暗示已完成,标记为 checkedIn(关联 recordId)
    await markPlanCheckedIn(plan.id, recordId);
  }
}
```

##### 规则 2: 计划打卡 → 习惯列表状态同步

```dart
Future<void> checkInFromPlan(String planId, HabitRecord record) async {
  // 1. 创建打卡记录,标记来源为 fromPlan
  final recordId = await insertRecord(record.copyWith(
    source: RecordSource.fromPlan,
    planId: planId,
  ));

  // 2. 更新计划状态为 checkedIn
  await markPlanCheckedIn(planId, recordId);

  // 3. 习惯列表自动刷新,显示"已打卡"状态
}
```

##### 规则 3: 取消打卡 → 双向同步

```dart
Future<void> cancelCheckIn(String recordId) async {
  // 1. 获取打卡记录
  final record = await getRecordById(recordId);

  if (record?.planId != null) {
    // 2. 如果来自计划,恢复计划状态为 cueCompleted
    await markCueCompleted(record!.planId!);
  }

  // 3. 删除打卡记录
  await deleteRecord(recordId);
}
```

#### 3.4.3 防重复打卡逻辑

```dart
Future<String?> checkInHabit({
  required String habitId,
  required DateTime date,
  required HabitRecord record,
}) async {
  // 1. 检查今日是否已打卡
  final hasRecord = await hasTodayRecord(habitId, date);

  if (hasRecord) {
    // 2. 已打卡,返回 null(UI 层弹出提示)
    return null;
  }

  // 3. 未打卡,插入记录
  final recordId = await insertRecord(record);

  // 4. 同步计划状态
  await syncPlanStatusAfterCheckIn(habitId, date, recordId);

  return recordId;
}
```

### 3.5 数据库迁移

#### Migration Script

```dart
// lib/core/database/migrations/migration_v2_plan_status.dart

class MigrationV2PlanStatus {
  static Future<void> migrate(Database db) async {
    await db.execute('''
      ALTER TABLE daily_plans
      ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'
    ''');

    await db.execute('''
      ALTER TABLE daily_plans
      ADD COLUMN record_id TEXT
    ''');

    await db.execute('''
      ALTER TABLE daily_plans
      ADD COLUMN cue_completed_at TIMESTAMP
    ''');

    await db.execute('''
      ALTER TABLE daily_plans
      ADD COLUMN checked_in_at TIMESTAMP
    ''');

    // 迁移旧数据: is_completed = true → status = 'checkedIn'
    await db.execute('''
      UPDATE daily_plans
      SET status = 'checkedIn'
      WHERE is_completed = 1
    ''');

    // HabitRecords 表
    await db.execute('''
      ALTER TABLE habit_records
      ADD COLUMN source TEXT NOT NULL DEFAULT 'fromList'
    ''');

    await db.execute('''
      ALTER TABLE habit_records
      ADD COLUMN plan_id TEXT
    ''');
  }
}
```

## 4. 技术实现要点

### 4.1 关键文件修改清单

| 文件路径 | 修改内容 |
|---------|---------|
| `lib/features/habits/domain/entities/daily_plan.dart` | 新增 `status`, `recordId`, `cueCompletedAt`, `checkedInAt` 字段 |
| `lib/features/habits/domain/entities/habit_record.dart` | 新增 `source`, `planId` 字段 |
| `lib/core/database/tables/daily_plans_table.dart` | 新增数据库字段 |
| `lib/core/database/tables/habit_records_table.dart` | 新增数据库字段 |
| `lib/core/database/app_database.dart` | 数据库版本号 +1,执行迁移脚本 |
| `lib/features/habits/domain/repositories/habit_repository.dart` | 新增状态管理方法 |
| `lib/features/habits/data/repositories/habit_repository_impl.dart` | 实现状态同步逻辑 |
| `lib/features/habits/presentation/screens/daily_plan_screen.dart` | 重构交互逻辑 |
| `lib/features/habits/presentation/widgets/habit_card.dart` | 新增打卡状态判断和显示 |

### 4.2 UI 组件设计

#### PlanCard 组件状态

```dart
class PlanCard extends ConsumerWidget {
  final DailyPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Row(
        children: [
          // 状态指示圆圈
          _buildStatusIndicator(plan.status),

          // 计划内容
          Expanded(child: _buildContent(plan)),

          // 操作按钮(仅 cueCompleted 显示)
          if (plan.isCueCompleted) _buildCheckInButton(),

          // 已打卡徽章
          if (plan.isCheckedIn) _buildCheckedInBadge(),

          // 已跳过徽章
          if (plan.isSkipped) _buildSkippedBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(PlanCompletionStatus status) {
    switch (status) {
      case PlanCompletionStatus.pending:
        return _emptyCircle(); // ○
      case PlanCompletionStatus.cueCompleted:
      case PlanCompletionStatus.checkedIn:
        return _filledCircle(); // ✓
      case PlanCompletionStatus.skipped:
        return _warningIcon(); // ⚠️
    }
  }

  Widget _buildCheckInButton() {
    return CupertinoButton(
      onPressed: () => _showCheckInDialog(),
      child: Text('打卡'),
    );
  }
}
```

### 4.3 Provider 层

```dart
// 新增 Provider: 今日打卡记录
final todayRecordProvider = FutureProvider.family<HabitRecord?, String>(
  (ref, habitId) async {
    final repository = ref.watch(habitRepositoryProvider);
    final today = DateTime.now();
    return await repository.getTodayRecord(habitId, today);
  },
);

// 修改 HabitCard: 监听今日打卡记录
class HabitCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayRecordAsync = ref.watch(todayRecordProvider(habit.id));

    return todayRecordAsync.when(
      data: (record) => _buildCard(hasRecord: record != null, record: record),
      loading: () => _buildCard(hasRecord: false),
      error: (_, __) => _buildCard(hasRecord: false),
    );
  }

  Widget _buildCheckInButton(bool hasRecord, HabitRecord? record) {
    if (hasRecord) {
      return _buildDisabledButton('已打卡', record!.quality);
    } else {
      return _buildActiveButton('打卡');
    }
  }
}
```

## 5. 验收标准

### 5.1 功能验收

- [ ] **状态流转正确**
  - [ ] pending → cueCompleted → checkedIn 流程正常
  - [ ] pending → skipped (习惯列表直接打卡)流程正常
  - [ ] 取消操作可正确回退状态

- [ ] **数据同步准确**
  - [ ] 习惯列表打卡后,计划自动标记为 skipped
  - [ ] 计划打卡后,习惯列表显示"已打卡"
  - [ ] 取消打卡后,双向状态正确恢复

- [ ] **防重复打卡**
  - [ ] 同一天无法重复打卡
  - [ ] 已打卡状态下,习惯列表打卡按钮禁用
  - [ ] 尝试重复打卡时有清晰提示

- [ ] **明日计划只读**
  - [ ] 明日计划 Tab 卡片置灰,不可点击
  - [ ] 或点击时弹出提示:"明天才能执行此计划"

### 5.2 UI/UX 验收

- [ ] **卡片状态清晰**
  - [ ] pending: 空心圆圈,无按钮
  - [ ] cueCompleted: 绿色勾 + "打卡"按钮
  - [ ] checkedIn: 绿色勾 + "已打卡"徽章 + 星级显示
  - [ ] skipped: 删除线 + "已跳过"徽章

- [ ] **交互流畅**
  - [ ] 点击卡片标记暗示完成 < 300ms
  - [ ] 打卡对话框弹出流畅
  - [ ] 状态切换有过渡动画

- [ ] **反馈及时**
  - [ ] 暗示完成后立即显示"打卡"按钮
  - [ ] 打卡成功后立即刷新卡片状态
  - [ ] 操作失败有错误提示

### 5.3 数据验收

- [ ] **数据库迁移成功**
  - [ ] 旧数据正确迁移(is_completed → status)
  - [ ] 新字段默认值正确

- [ ] **数据一致性**
  - [ ] DailyPlan.recordId 与 HabitRecord.id 正确关联
  - [ ] HabitRecord.planId 与 DailyPlan.id 正确关联
  - [ ] 删除打卡记录时,计划状态正确更新

### 5.4 测试场景

#### 场景 1: 完整流程测试

```
1. 创建次日计划(明天)
2. 等待到明天(或手动修改数据库日期)
3. 查看今日计划,计划状态为 pending
4. 点击卡片,状态变为 cueCompleted
5. 点击"打卡"按钮,弹出对话框
6. 填写质量 5 星,提交
7. 验证计划状态为 checkedIn,显示星级
8. 验证习惯列表显示"已打卡"
9. 尝试在习惯列表再次打卡,按钮禁用
```

#### 场景 2: 跳过计划测试

```
1. 创建今日计划
2. 不查看计划,直接在习惯列表打卡
3. 验证计划状态自动变为 skipped
4. 验证卡片显示删除线和"已跳过"徽章
```

#### 场景 3: 取消打卡测试

```
1. 完成打卡(场景 1)
2. 点击计划卡片取消打卡
3. 验证状态回退为 cueCompleted
4. 验证打卡记录已删除
5. 验证习惯列表恢复"打卡"按钮
```

#### 场景 4: 明日计划只读测试

```
1. 创建明日计划
2. 切换到"明日计划"Tab
3. 验证卡片置灰
4. 点击卡片,无响应或弹出提示
```

## 6. 开发计划

### 6.1 Phase 1: 数据层改造 (2 小时)

- [ ] 修改 `DailyPlan` 和 `HabitRecord` 实体
- [ ] 运行 Freezed 代码生成
- [ ] 修改数据库表定义
- [ ] 编写迁移脚本
- [ ] 更新数据库版本号
- [ ] 测试迁移脚本

### 6.2 Phase 2: 业务逻辑实现 (3 小时)

- [ ] Repository 接口新增方法
- [ ] 实现状态流转方法
- [ ] 实现状态同步逻辑
- [ ] 实现防重复打卡逻辑
- [ ] 单元测试(状态流转、同步逻辑)

### 6.3 Phase 3: UI 层重构 (3 小时)

- [ ] 重构 DailyPlanScreen 交互逻辑
  - [ ] 移除二选一对话框
  - [ ] 实现点击卡片标记暗示完成
  - [ ] 实现"打卡"按钮(仅 cueCompleted 显示)
  - [ ] 实现明日计划只读
- [ ] 重构 PlanCard 组件
  - [ ] 状态指示器(4 种状态)
  - [ ] 条件渲染"打卡"按钮
  - [ ] 已打卡/已跳过徽章
- [ ] 重构 HabitCard 组件
  - [ ] 新增打卡状态判断
  - [ ] 禁用已打卡按钮
  - [ ] 显示今日打卡星级

### 6.4 Phase 4: 测试与优化 (2 小时)

- [ ] Widget 测试(PlanCard 各状态)
- [ ] 集成测试(4 个场景)
- [ ] 性能优化(Provider 刷新策略)
- [ ] UI 细节打磨(动画、反馈)

### 6.5 Phase 5: 文档更新 (1 小时)

- [ ] 更新 FAQ.md
- [ ] 更新 DAILY_PLAN_USER_GUIDE.md
- [ ] 更新 PLAN.md

**总预计时间**: 11 小时

## 7. 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 数据库迁移失败 | 高 | 迁移前自动备份,提供回滚脚本 |
| 旧数据兼容性问题 | 中 | 充分测试迁移逻辑,提供数据修复工具 |
| UI 状态管理复杂 | 中 | 使用状态机模式,清晰定义状态流转规则 |
| Provider 刷新性能 | 低 | 使用 family 精确刷新,避免全局刷新 |

## 8. 附录

### 8.1 参考文档

- [PLAN.md - Phase 2 Task 2.12](../../PLAN.md#task-212-次日计划功能-)
- [DAILY_PLAN_USER_GUIDE.md](../habit/DAILY_PLAN_USER_GUIDE.md)
- [FAQ.md - Q1](../FAQ.md#q1-习惯列表的今日打卡和次日计划完成暗示并打卡有什么区别)

### 8.2 决策记录

**决策点 1**: 明日计划是否允许操作?
- **选择**: B - 只读,不可操作
- **理由**: 明天还没到,不应该提前完成暗示

**决策点 2**: 习惯列表打卡后,计划状态如何处理?
- **选择**: A - 自动标记为 skipped
- **理由**: 保留计划记录,方便分析"暗示触发率"

**决策点 3**: "仅标记完成"后的补打卡入口?
- **选择**: A - 在计划卡片上显示"打卡"按钮
- **理由**: 最直观,减少操作步骤

**决策点 4**: 同一天重复打卡的处理策略?
- **选择**: A - 完全阻止
- **理由**: 符合"一天一次"的习惯理念

**决策点 5**: 点击卡片的默认行为?
- **选择**: 点击卡片 = 标记暗示完成(pending → cueCompleted)
- **理由**: 减少操作步骤,暗示完成后自动显示"打卡"按钮

---

**文档版本**: v1.0.0
**最后更新**: 2025-10-05
**负责人**: @flutter_architect
