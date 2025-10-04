# 习惯模块需求文档与实现方案

## 1. 产品概述

基于《习惯的力量》一书的核心理论，实现一个帮助用户建立和追踪习惯的模块。该模块强调习惯循环的三要素（暗示-惯常行为-奖赏），并支持习惯替代功能，帮助用户改变不良习惯。

### 1.1 核心理论

**编辑习惯**
- 修改习惯的任意字段
- 更新执行记录不受影响

**删除习惯**
- 软删除（保留历史数据）
- 可恢复已删除的习惯

**查看习惯列表**
- 显示所有活跃习惯
- 按分类筛选
- 按创建时间/最后执行时间排序
- 快速查看习惯完成状态

#### 2.1.2 习惯执行与追踪

**打卡记录**
- 记录习惯执行时间
- 记录执行质量（可选）
- 添加执行笔记（可选）
- 支持补打卡（过去日期）

**执行统计**
- 连续执行天数（Streak）
- 总执行次数
- 本周/本月执行次数
- 完成率分析
- 最佳执行时间段

**可视化展示**
- 日历热力图（类似GitHub贡献图）
- 趋势折线图
- 习惯完成率饼图

#### 2.1.3 次日计划生成

**自动生成功能**
- 选择要计划的习惯
- 自动将习惯的"暗示"转换为待办事项
- 生成完整的次日计划清单
- 按优先级排序

**计划管理**
- 查看次日计划
- 调整计划顺序
- 标记计划完成
- 计划完成后自动关联到习惯打卡

**示例流程**：
```
用户选择习惯：
1. 去图书馆学习
2. 卷腹运动

生成次日计划：
□ 准备好书包放在一进门就能看到的椅子上（7:00 AM）
□ 出门前将瑜伽垫铺在地上（8:00 PM）

完成暗示准备后：
→ 自动触发惯常行为提醒
→ 执行行为后打卡
→ 记录奖赏体验
```

#### 2.1.4 Frontmatter（习惯感悟）

**功能说明**
- 类似Markdown的frontmatter，记录习惯带来的长期感悟
- 记录习惯的强大力量和个人体会
- 追踪习惯如何渗透到生活中
- 记录不自觉执行习惯的时刻

**内容结构**
```yaml
---
title: 习惯的力量
created: 2024-01-01
updated: 2024-10-04
tags: [自律, 成长, 习惯养成]
---

# 我的习惯感悟

习惯具有强大的主导力，不可抵抗的力量。养成考虑顺序的习惯。

## 已内化的习惯

这些习惯已经渗透到我的生活，并且被我不自觉地执行：

1. **去图书馆的习惯**
   - 即使下雨、即使便秘10点也要坚持
   - 已经成为我的一部分

2. **周末学习习惯**
   - 养成了周末上午、晚上去图书馆的习惯
   - 即使20:30也会去

3. **卷腹习惯**
   - 不知不觉间已经养成

## 习惯带来的改变

- 自律的实现让我精神满足
- 对自己的掌控力显著提升
- 腹肌带来的自信，它是我坚持的见证
```

**编辑功能**
- Markdown编辑器
- 支持标签管理
- 时间线展示感悟变化
- 与习惯关联显示

---

## 3. 数据模型设计

### 3.1 数据库表结构

#### 3.1.1 Habits（习惯表）

```dart
class Habit {
  final String id;              // UUID
  final String name;            // 习惯名称
  final String cue;             // 暗示
  final String routine;         // 惯常行为
  final String? oldRoutine;     // 原惯常行为（习惯替代时使用）
  final String reward;          // 奖赏
  final HabitType type;         // 类型：POSITIVE 或 REPLACEMENT
  final String? category;       // 分类标签
  final String? notes;          // 备注
  final bool isActive;          // 是否活跃
  final DateTime createdAt;     // 创建时间
  final DateTime updatedAt;     // 更新时间
  final DateTime? deletedAt;    // 删除时间（软删除）
}

enum HabitType {
  POSITIVE,      // 正向习惯
  REPLACEMENT    // 习惯替代
}
```

#### 3.1.2 HabitRecords（习惯执行记录表）

```dart
class HabitRecord {
  final String id;              // UUID
  final String habitId;         // 关联的习惯ID
  final DateTime executedAt;    // 执行时间
  final int? quality;           // 执行质量（1-5星）
  final String? notes;          // 执行笔记
  final bool isBackfilled;      // 是否是补打卡
  final DateTime createdAt;     // 记录创建时间
}
```

#### 3.1.3 DailyPlans（次日计划表）

```dart
class DailyPlan {
  final String id;              // UUID
  final DateTime planDate;      // 计划日期
  final String habitId;         // 关联的习惯ID
  final String cueTask;         // 暗示任务（从习惯复制）
  final DateTime? scheduledTime;// 计划执行时间
  final int priority;           // 优先级
  final bool isCompleted;       // 是否完成
  final DateTime? completedAt;  // 完成时间
  final String? recordId;       // 关联的执行记录ID
  final DateTime createdAt;     // 创建时间
}
```

#### 3.1.4 HabitFrontmatter（习惯感悟表）

```dart
class HabitFrontmatter {
  final String id;              // UUID
  final String title;           // 标题
  final String content;         // Markdown内容
  final List<String> tags;      // 标签
  final DateTime createdAt;     // 创建时间
  final DateTime updatedAt;     // 更新时间
  final Map<String, dynamic> metadata; // 扩展元数据
}
```

### 3.2 SQLite DDL

```sql
-- 习惯表
CREATE TABLE habits (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  cue TEXT NOT NULL,
  routine TEXT NOT NULL,
  old_routine TEXT,
  reward TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('POSITIVE', 'REPLACEMENT')),
  category TEXT,
  notes TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER
);

CREATE INDEX idx_habits_is_active ON habits(is_active);
CREATE INDEX idx_habits_type ON habits(type);
CREATE INDEX idx_habits_category ON habits(category);

-- 执行记录表
CREATE TABLE habit_records (
  id TEXT PRIMARY KEY,
  habit_id TEXT NOT NULL,
  executed_at INTEGER NOT NULL,
  quality INTEGER CHECK(quality >= 1 AND quality <= 5),
  notes TEXT,
  is_backfilled INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE
);

CREATE INDEX idx_records_habit_id ON habit_records(habit_id);
CREATE INDEX idx_records_executed_at ON habit_records(executed_at);

-- 次日计划表
CREATE TABLE daily_plans (
  id TEXT PRIMARY KEY,
  plan_date INTEGER NOT NULL,
  habit_id TEXT NOT NULL,
  cue_task TEXT NOT NULL,
  scheduled_time INTEGER,
  priority INTEGER NOT NULL DEFAULT 0,
  is_completed INTEGER NOT NULL DEFAULT 0,
  completed_at INTEGER,
  record_id TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE,
  FOREIGN KEY (record_id) REFERENCES habit_records(id) ON DELETE SET NULL
);

CREATE INDEX idx_plans_date ON daily_plans(plan_date);
CREATE INDEX idx_plans_habit_id ON daily_plans(habit_id);
CREATE INDEX idx_plans_completed ON daily_plans(is_completed);

-- 习惯感悟表
CREATE TABLE habit_frontmatters (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  tags TEXT NOT NULL, -- JSON数组
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  metadata TEXT -- JSON对象
);

CREATE INDEX idx_frontmatters_created_at ON habit_frontmatters(created_at);
```

---

## 4. UI/UX 设计

### 4.1 页面结构

#### 4.1.1 习惯列表页（主页）

**布局：**
```
┌─────────────────────────────────────┐
│  习惯追踪              [Frontmatter] │
│  [+ 添加习惯]                        │
├─────────────────────────────────────┤
│  🔍 搜索  |  📁 分类  |  🎯 状态     │
├─────────────────────────────────────┤
│  📚 去图书馆学习                    │
│  ├ 暗示: 准备书包放显眼位置        │
│  ├ 连续: 🔥 15天                    │
│  └ [✓ 今日打卡]          [详情 >]   │
├─────────────────────────────────────┤
│  💪 卷腹运动                        │
│  ├ 暗示: 铺瑜伽垫在地上            │
│  ├ 连续: 🔥 7天                     │
│  └ [✓ 今日打卡]          [详情 >]   │
├─────────────────────────────────────┤
│  🥤 健康饮食 [替代]                │
│  ├ 暗示: 无聊想刺激                │
│  ├ 连续: 🔥 3天                     │
│  └ [ 今日打卡]           [详情 >]   │
└─────────────────────────────────────┘
```

**功能组件：**
- 习惯卡片（SwipeAction支持删除/编辑）
- 连续天数徽章
- 快速打卡按钮
- 分类筛选器
- 搜索框

#### 4.1.2 习惯详情页

**布局：**
```
┌─────────────────────────────────────┐
│  < 返回    去图书馆学习      [编辑] │
├─────────────────────────────────────┤
│  📋 习惯循环                        │
│  ┌───────────────────────────────┐  │
│  │ 🔔 暗示                       │  │
│  │ 准备好书包放在一进门就能看    │  │
│  │ 到的椅子或桌子上              │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 🏃 惯常行为                   │  │
│  │ 拿起书包去图书馆              │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 🎁 奖赏                       │  │
│  │ 自律的实现让我精神满足，      │  │
│  │ 对自己的掌控力                │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  📊 执行统计                        │
│  ┌─────┬─────┬─────┬─────┐         │
│  │连续 │总计 │本周 │完成率│         │
│  │15天 │45次 │5次  │90%  │         │
│  └─────┴─────┴─────┴─────┘         │
│                                     │
│  [日历热力图]                       │
│  一 二 三 四 五 六 日                │
│  ■ ■ ■ □ ■ ■ ■                   │
│  ■ ■ ■ ■ □ ■ ■                   │
├─────────────────────────────────────┤
│  📝 执行记录                        │
│  2024-10-04 20:30 ⭐⭐⭐⭐⭐       │
│  备注: 今天效率特别高               │
│                                     │
│  2024-10-03 19:00 ⭐⭐⭐⭐         │
│  备注: 稍微有点累但坚持了           │
├─────────────────────────────────────┤
│  [今日打卡]       [查看完整记录]    │
└─────────────────────────────────────┘
```

#### 4.1.3 创建/编辑习惯页

**布局：**
```
┌─────────────────────────────────────┐
│  < 返回      添加习惯      [保存]   │
├─────────────────────────────────────┤
│  习惯名称                           │
│  ┌───────────────────────────────┐  │
│  │ 去图书馆学习                  │  │
│  └───────────────────────────────┘  │
│                                     │
│  习惯类型                           │
│  ○ 正向习惯  ● 习惯替代             │
│                                     │
│  🔔 暗示（触发条件）                │
│  ┌───────────────────────────────┐  │
│  │ 准备好书包放在一进门就能看到  │  │
│  │ 的椅子或桌子上                │  │
│  └───────────────────────────────┘  │
│  💡 提示：暗示越具体，越容易触发    │
│                                     │
│  [如果是习惯替代，显示原惯常行为]   │
│  ❌ 原惯常行为                      │
│  ┌───────────────────────────────┐  │
│  │ （选填）                      │  │
│  └───────────────────────────────┘  │
│                                     │
│  🏃 惯常行为（要执行的动作）        │
│  ┌───────────────────────────────┐  │
│  │ 拿起书包去图书馆              │  │
│  └───────────────────────────────┘  │
│                                     │
│  🎁 奖赏（行为带来的收益）          │
│  ┌───────────────────────────────┐  │
│  │ 自律的实现让我精神满足，      │  │
│  │ 对自己的掌控力                │  │
│  └───────────────────────────────┘  │
│  💡 提示：明确奖赏有助于习惯养成    │
│                                     │
│  📁 分类标签                        │
│  ┌───────────────────────────────┐  │
│  │ 学习 ▼                        │  │
│  └───────────────────────────────┘  │
│                                     │
│  📝 备注                            │
│  ┌───────────────────────────────┐  │
│  │ （选填）                      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

#### 4.1.4 次日计划页

**布局：**
```
┌─────────────────────────────────────┐
│  < 返回    明日计划      [生成计划] │
│  2024年10月5日 星期六               │
├─────────────────────────────────────┤
│  从习惯生成 ┃ 手动添加              │
├─────────────────────────────────────┤
│  ☐ 7:00 AM                          │
│    准备好书包放在一进门就能看到的   │
│    椅子或桌子上                     │
│    → 关联: 去图书馆学习             │
│    [标记完成]                       │
├─────────────────────────────────────┤
│  ☐ 8:00 PM                          │
│    出门前将瑜伽垫铺在地上           │
│    → 关联: 卷腹运动                 │
│    [标记完成]                       │
├─────────────────────────────────────┤
│  ☑ 9:00 AM                          │
│    准备健康零食（已完成）           │
│    → 关联: 健康饮食                 │
│    ✓ 已关联到打卡记录               │
└─────────────────────────────────────┘
```

**生成计划对话框：**
```
┌─────────────────────────────────────┐
│  选择要计划的习惯                   │
│                                     │
│  ☑ 去图书馆学习                    │
│    建议时间: 7:00 AM                │
│                                     │
│  ☑ 卷腹运动                        │
│    建议时间: 8:00 PM                │
│                                     │
│  ☐ 健康饮食                        │
│    建议时间: 全天                   │
│                                     │
│  [取消]              [生成计划]     │
└─────────────────────────────────────┘
```

#### 4.1.5 Frontmatter（习惯感悟）页

**布局：**
```
┌─────────────────────────────────────┐
│  < 返回    习惯感悟         [编辑]  │
├─────────────────────────────────────┤
│  ---                                │
│  title: 习惯的力量                  │
│  created: 2024-01-01                │
│  updated: 2024-10-04                │
│  tags: [自律, 成长, 习惯养成]       │
│  ---                                │
│                                     │
│  # 我的习惯感悟                     │
│                                     │
│  习惯具有强大的主导力，不可抵抗的   │
│  力量。养成考虑顺序的习惯。         │
│                                     │
│  ## 已内化的习惯                    │
│                                     │
│  这些习惯已经渗透到我的生活，并且   │
│  被我不自觉地执行：                 │
│                                     │
│  1. **去图书馆的习惯**              │
│     - 即使下雨、即使便秘10点也要坚持│
│     - 已经成为我的一部分            │
│                                     │
│  2. **周末学习习惯**                │
│     - 养成了周末上午、晚上去图书馆  │
│       的习惯                        │
│     - 即使20:30也会去               │
│                                     │
│  ## 习惯带来的改变                  │
│                                     │
│  - 自律的实现让我精神满足           │
│  - 对自己的掌控力显著提升           │
│  - 腹肌带来的自信，它是我坚持的见证│
└─────────────────────────────────────┘
```

**编辑模式：**
- Markdown实时预览
- 支持富文本工具栏
- 标签选择器
- 自动保存草稿

### 4.2 交互设计

#### 4.2.1 打卡流程

```
用户点击"今日打卡" 
    ↓
显示打卡对话框
    ├─ 执行时间（默认当前）
    ├─ 执行质量（1-5星）
    └─ 执行笔记（可选）
    ↓
点击"确认打卡"
    ↓
记录保存 + 动画反馈
    ├─ ✓ 图标放大动画
    ├─ 连续天数+1
    └─ 成就通知（如连续7天、30天等）
    ↓
返回列表页，卡片更新
```

#### 4.2.2 计划生成流程

```
用户打开"次日计划"页
    ↓
点击"生成计划"
    ↓
显示习惯选择对话框
    ├─ 列出所有活跃习惯
    ├─ 默认全选
    └─ 建议执行时间
    ↓
用户调整选择和时间
    ↓
点击"生成计划"
    ↓
系统自动生成计划列表
    ├─ 将"暗示"作为任务
    ├─ 按时间排序
    └─ 关联对应习惯
    ↓
计划列表展示
```

#### 4.2.3 计划完成到打卡流程

```
用户标记计划完成
    ↓
系统检测是否关联习惯
    ↓
如果关联习惯，弹出确认
    "暗示已完成，是否执行惯常行为并打卡？"
    ├─ 是 → 跳转到打卡对话框（预填习惯）
    └─ 否 → 仅标记计划完成
    ↓
完成打卡后自动关联
    ├─ daily_plans.record_id = record.id
    └─ daily_plans.completed_at = now()
```

---

## 5. 技术实现方案

### 5.1 技术栈

- **框架**: Flutter 3.35.5
- **状态管理**: Riverpod 2.x
- **本地数据库**: Drift (SQLite)
- **路由**: go_router
- **UI风格**: Cupertino (iOS风格)

### 5.2 项目结构

```
lib/features/habits/
├── data/
│   ├── datasources/
│   │   └── habit_local_datasource.dart     # 本地数据源
│   ├── models/
│   │   ├── habit_model.dart                # 习惯数据模型
│   │   ├── habit_record_model.dart         # 执行记录模型
│   │   ├── daily_plan_model.dart           # 次日计划模型
│   │   └── habit_frontmatter_model.dart    # Frontmatter模型
│   └── repositories/
│       └── habit_repository_impl.dart      # 仓库实现
├── domain/
│   ├── entities/
│   │   ├── habit.dart                      # 习惯实体
│   │   ├── habit_record.dart               # 记录实体
│   │   ├── daily_plan.dart                 # 计划实体
│   │   └── habit_frontmatter.dart          # Frontmatter实体
│   ├── repositories/
│   │   └── habit_repository.dart           # 仓库接口
│   └── usecases/
│       ├── create_habit.dart               # 创建习惯用例
│       ├── get_habits.dart                 # 获取习惯列表
│       ├── record_habit_execution.dart     # 记录执行
│       ├── generate_daily_plan.dart        # 生成次日计划
│       └── ...                             # 其他用例
├── presentation/
│   ├── providers/
│   │   ├── habit_provider.dart             # 习惯状态提供者
│   │   ├── habit_record_provider.dart      # 记录状态提供者
│   │   ├── daily_plan_provider.dart        # 计划状态提供者
│   │   └── frontmatter_provider.dart       # Frontmatter状态
│   ├── screens/
│   │   ├── habits_screen.dart              # 习惯列表页
│   │   ├── habit_detail_screen.dart        # 习惯详情页
│   │   ├── habit_form_screen.dart          # 创建/编辑页
│   │   ├── daily_plan_screen.dart          # 次日计划页
│   │   └── frontmatter_screen.dart         # Frontmatter页
│   └── widgets/
│       ├── habit_card.dart                 # 习惯卡片
│       ├── habit_calendar_heatmap.dart     # 日历热力图
│       ├── habit_stats_card.dart           # 统计卡片
│       ├── check_in_dialog.dart            # 打卡对话框
│       └── plan_generator_dialog.dart      # 计划生成对话框
└── ...
```

### 5.3 核心代码示例

#### 5.3.1 实体定义

```dart
// lib/features/habits/domain/entities/habit.dart
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
```

```dart
// lib/features/habits/domain/entities/habit_record.dart
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

```dart
// lib/features/habits/domain/entities/daily_plan.dart
@freezed
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required String id,
    required DateTime planDate,
    required String habitId,
    required String cueTask,
    DateTime? scheduledTime,
    required int priority,
    required bool isCompleted,
    DateTime? completedAt,
    String? recordId,
    required DateTime createdAt,
  }) = _DailyPlan;
}
```

#### 5.3.2 Drift数据库配置

```dart
// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Habits, HabitRecords, DailyPlans, HabitFrontmatters],
  daos: [HabitDao, HabitRecordDao, DailyPlanDao, FrontmatterDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wudao_db');
  }
}

@DataClassName('HabitData')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get cue => text()();
  TextColumn get routine => text()();
  TextColumn get oldRoutine => text().nullable()();
  TextColumn get reward => text()();
  TextColumn get type => textEnum<HabitType>()();
  TextColumn get category => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HabitRecordData')
class HabitRecords extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get executedAt => dateTime()();
  IntColumn get quality => integer().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isBackfilled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

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

@DataClassName('HabitFrontmatterData')
class HabitFrontmatters extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get tags => text()(); // JSON array
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get metadata => text().nullable()(); // JSON object

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 5.3.3 Repository实现

```dart
// lib/features/habits/data/repositories/habit_repository_impl.dart
class HabitRepositoryImpl implements HabitRepository {
  final HabitDao _habitDao;
  final HabitRecordDao _recordDao;
  final DailyPlanDao _planDao;

  HabitRepositoryImpl({
    required HabitDao habitDao,
    required HabitRecordDao recordDao,
    required DailyPlanDao planDao,
  })  : _habitDao = habitDao,
        _recordDao = recordDao,
        _planDao = planDao;

  @override
  Future<Habit> createHabit(Habit habit) async {
    await _habitDao.insertHabit(habit.toData());
    return habit;
  }

  @override
  Stream<List<Habit>> watchActiveHabits() {
    return _habitDao.watchActiveHabits().map((list) => 
      list.map((data) => data.toEntity()).toList()
    );
  }

  @override
  Future<void> recordExecution(HabitRecord record) async {
    await _recordDao.insertRecord(record.toData());
  }

  @override
  Future<List<DailyPlan>> generateDailyPlan({
    required DateTime date,
    required List<String> habitIds,
  }) async {
    final habits = await _habitDao.getHabitsByIds(habitIds);
    final plans = <DailyPlan>[];
    
    for (var i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final plan = DailyPlan(
        id: const Uuid().v4(),
        planDate: date,
        habitId: habit.id,
        cueTask: habit.cue,
        scheduledTime: null,
        priority: i,
        isCompleted: false,
        completedAt: null,
        recordId: null,
        createdAt: DateTime.now(),
      );
      
      await _planDao.insertPlan(plan.toData());
      plans.add(plan);
    }
    
    return plans;
  }

  @override
  Future<HabitStats> getHabitStats(String habitId) async {
    final records = await _recordDao.getRecordsByHabitId(habitId);
    
    // 计算连续天数
    int currentStreak = _calculateCurrentStreak(records);
    
    // 计算总执行次数
    int totalExecutions = records.length;
    
    // 计算本周执行次数
    int thisWeekExecutions = _calculateThisWeekExecutions(records);
    
    // 计算完成率（假设每天一次）
    double completionRate = _calculateCompletionRate(records);
    
    return HabitStats(
      currentStreak: currentStreak,
      totalExecutions: totalExecutions,
      thisWeekExecutions: thisWeekExecutions,
      completionRate: completionRate,
    );
  }

  int _calculateCurrentStreak(List<HabitRecordData> records) {
    if (records.isEmpty) return 0;
    
    // 按日期降序排序
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
      
      if (recordDate == checkDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  int _calculateThisWeekExecutions(List<HabitRecordData> records) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return records.where((record) =>
      record.executedAt.isAfter(weekStart)
    ).length;
  }

  double _calculateCompletionRate(List<HabitRecordData> records) {
    if (records.isEmpty) return 0.0;
    
    final firstRecord = records.reduce((a, b) =>
      a.executedAt.isBefore(b.executedAt) ? a : b
    );
    
    final daysSinceStart = DateTime.now().difference(firstRecord.executedAt).inDays + 1;
    
    return records.length / daysSinceStart;
  }
}
```

#### 5.3.4 Riverpod Providers

```dart
// lib/features/habits/presentation/providers/habit_provider.dart
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return HabitRepositoryImpl(
    habitDao: database.habitDao,
    recordDao: database.habitRecordDao,
    planDao: database.dailyPlanDao,
  );
});

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchActiveHabits();
});

final habitStatsProvider = FutureProvider.family<HabitStats, String>((ref, habitId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitStats(habitId);
});

final dailyPlanProvider = StreamProvider.family<List<DailyPlan>, DateTime>((ref, date) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchDailyPlans(date);
});
```

#### 5.3.5 UI组件示例

```dart
// lib/features/habits/presentation/widgets/habit_card.dart
class HabitCard extends ConsumerWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(habitStatsProvider(habit.id));

    return CupertinoListTile(
      title: Row(
        children: [
          Text(habit.name),
          if (habit.type == HabitType.replacement)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CupertinoColors.systemOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '替代',
                style: TextStyle(
                  fontSize: 10,
                  color: CupertinoColors.systemOrange,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '暗示: ${habit.cue}',
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          statsAsync.when(
            data: (stats) => Row(
              children: [
                const Text('🔥'),
                const SizedBox(width: 4),
                Text(
                  '${stats.currentStreak}天',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.checkmark_circle),
        onPressed: () => _showCheckInDialog(context, ref),
      ),
      onTap: () {
        // 导航到详情页
        context.push('/habits/${habit.id}');
      },
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

```dart
// lib/features/habits/presentation/widgets/check_in_dialog.dart
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
          
          // 执行时间
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('执行时间'),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  '${_executedAt.hour}:${_executedAt.minute.toString().padLeft(2, '0')}',
                ),
                onPressed: () => _showTimePicker(context),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 执行质量
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
          
          // 执行笔记
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

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 200,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: _executedAt,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() => _executedAt = newDateTime);
          },
        ),
      ),
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
        
        // 显示成功提示
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Column(
              children: [
                const Text('✓', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text('打卡成功！连续${ref.read(habitStatsProvider(widget.habit.id)).value?.currentStreak ?? 0}天'),
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

---

## 6. 实现步骤

### 阶段一：基础架构（1-2天）

1. **数据库层**
   - 创建Drift表定义
   - 实现DAO层
   - 编写迁移脚本

2. **领域层**
   - 定义实体
   - 创建仓库接口
   - 实现用例

3. **数据层**
   - 实现数据源
   - 实现仓库

### 阶段二：核心功能（3-4天）

1. **习惯管理**
   - 创建/编辑/删除习惯
   - 习惯列表页面
   - 习惯详情页面

2. **打卡功能**
   - 打卡对话框
   - 记录保存
   - 统计计算

3. **数据展示**
   - 连续天数计算
   - 日历热力图
   - 统计图表

### 阶段三：高级功能（2-3天）

1. **次日计划**
   - 计划生成逻辑
   - 计划管理界面
   - 计划与打卡关联

2. **Frontmatter**
   - Markdown编辑器
   - 标签管理
   - 时间线展示

### 阶段四：优化与测试（1-2天）

1. **性能优化**
   - 数据库查询优化
   - UI渲染优化
   - 内存管理

2. **用户体验**
   - 动画效果
   - 交互反馈
   - 错误处理

3. **测试**
   - 单元测试
   - 集成测试
   - UI测试

---

## 7. 数据示例

### 7.1 示例习惯数据

```json
{
  "id": "habit-001",
  "name": "去图书馆学习",
  "cue": "准备好书包放在一进门就能看到的椅子或桌子上",
  "routine": "拿起书包去图书馆",
  "reward": "自律的实现让我精神满足，对自己的掌控力",
  "type": "POSITIVE",
  "category": "学习",
  "isActive": true,
  "createdAt": "2024-01-01T08:00:00Z",
  "updatedAt": "2024-10-04T20:00:00Z"
}
```

```json
{
  "id": "habit-002",
  "name": "健康饮食",
  "cue": "很无聊，想找刺激",
  "oldRoutine": "喝奶茶、碳酸饮料",
  "routine": "喝一瓶冰酸奶或冰的电解质饮料",
  "reward": "享受刺激感，同时保持健康",
  "type": "REPLACEMENT",
  "category": "健康",
  "isActive": true,
  "createdAt": "2024-02-01T08:00:00Z",
  "updatedAt": "2024-10-04T20:00:00Z"
}
```

### 7.2 示例执行记录

```json
{
  "id": "record-001",
  "habitId": "habit-001",
  "executedAt": "2024-10-04T20:30:00Z",
  "quality": 5,
  "notes": "今天效率特别高，完成了很多任务",
  "isBackfilled": false,
  "createdAt": "2024-10-04T20:35:00Z"
}
```

### 7.3 示例次日计划

```json
{
  "id": "plan-001",
  "planDate": "2024-10-05T00:00:00Z",
  "habitId": "habit-001",
  "cueTask": "准备好书包放在一进门就能看到的椅子或桌子上",
  "scheduledTime": "2024-10-05T07:00:00Z",
  "priority": 0,
  "isCompleted": false,
  "createdAt": "2024-10-04T21:00:00Z"
}
```

---

## 8. 潜在扩展功能

1. **社交功能**
   - 习惯分享
   - 好友互相监督
   - 习惯排行榜

2. **AI辅助**
   - 习惯推荐
   - 暗示优化建议
   - 奖赏设计建议

3. **数据分析**
   - 习惯完成率趋势
   - 最佳执行时间分析
   - 习惯相关性分析

4. **提醒系统**
   - 暗示提醒
   - 打卡提醒
   - 计划提醒

5. **导出功能**
   - 导出习惯数据
   - 生成习惯报告
   - 分享习惯成就

---

## 9. 注意事项

1. **数据隐私**
   - 所有数据本地存储
   - 不上传到服务器
   - 支持数据备份

2. **用户体验**
   - 操作简单直观
   - 减少输入负担
   - 及时反馈

3. **性能考虑**
   - 大量数据时的查询优化
   - UI渲染性能
   - 内存使用

4. **可维护性**
   - 清晰的代码结构
   - 完善的注释
   - 单元测试覆盖

---

## 10. 总结

这个习惯模块基于《习惯的力量》的科学理论，将帮助用户：

1. **建立好习惯**：通过明确的暗示-行为-奖赏循环
2. **改变坏习惯**：通过习惯替代机制
3. **持续追踪**：通过打卡和统计功能
4. **提前规划**：通过次日计划功能
5. **深度反思**：通过Frontmatter记录感悟

整个设计注重实用性和易用性，帮助用户真正养成长期有益的习惯。习惯循环三要素：**
- **暗示（Cue）**：触发习惯的环境或情境信号
- **惯常行为（Routine）**：习惯性执行的动作
- **奖赏（Reward）**：行为带来的满足感或收益

**习惯替代（Habit Replacement）**：
- 保持相同的暗示和奖赏
- 改变中间的惯常行为
- 用于纠正不良习惯

---

## 2. 功能需求

### 2.1 核心功能

#### 2.1.1 习惯管理

**创建习惯**
- 输入习惯名称
- 定义暗示（触发条件）
- 定义惯常行为（要执行的动作）
- 定义奖赏（精神或物质回报）
- 选择习惯类型：
  - 正向习惯（建立新习惯）
  - 习惯替代（改变不良习惯）
- 设置习惯标签/分类
- 添加备注说明

**习惯类型说明：**

1. **正向习惯示例**：
   ```
   名称：去图书馆学习
   暗示：准备好书包放在一进门就能看到的椅子或桌子上
   惯常行为：拿起书包去图书馆
   奖赏：自律的实现让我精神满足，对自己的掌控力
   类型：正向习惯
   ```

2. **习惯替代示例**：
   ```
   名称：健康饮食习惯
   暗示：很无聊，想找刺激
   原惯常行为：喝奶茶、碳酸饮料（甜的和冰的）
   新惯常行为：喝一瓶冰酸奶或冰的电解质饮料
   奖赏：刺激感、享受
   类型：习惯替代
   ```

**