# 习惯模块 - 文档导航

> 基于《习惯的力量》理论，为悟道应用打造的习惯追踪模块

---

## 📚 核心文档

### 1. **完整需求文档** (推荐首先阅读)

**文件**: [`../habit_module_requirements.md`](../habit_module_requirements.md) (1458 行)

**内容**:
- 完整的产品需求说明（习惯循环理论、习惯替代机制）
- 详细的数据模型设计（4 张表 + 索引策略）
- UI/UX 设计方案（5 个页面布局 + 交互流程）
- 完整的技术实现方案（Drift + Riverpod + Cupertino）
- 核心代码示例（实体、DAO、Repository、UI 组件）

**用途**: 理解习惯模块的完整设计思路和实现细节

---

### 2. **快速开始指南**

**文件**: [`./HABIT_QUICK_START.md`](./HABIT_QUICK_START.md)

**内容**:
- 20 分钟快速搭建基础架构
- 最新依赖版本配置（Riverpod 3.0, Drift 2.20.0+）
- 核心功能的完整代码
- 测试步骤和常见问题解答

**用途**: 快速上手，立即看到可运行的 MVP

---

### 2.5 **次日计划用户指南** ✨ 新增

**文件**: [`./DAILY_PLAN_USER_GUIDE.md`](./DAILY_PLAN_USER_GUIDE.md)

**内容**:
- 次日计划功能完整使用说明
- 计划生成器详细操作指南
- UI 交互流程和最佳实践
- 常见问题解答
- 未来功能规划（定时提醒）

**用途**: 理解和使用次日计划功能，提前规划习惯触发条件

---

### 3. **开发计划** (任务清单)

**文件**: [`../../PLAN.md`](../../PLAN.md) - Phase 2 部分

**内容**:
- 详细的 4 周实施计划
- 按周分解的任务清单（Task 2.1 - 2.16）
- 每个任务的负责人和预计时间
- Phase 2 验收标准

**用途**: 作为开发过程中的任务检查清单

---

### 4. **项目总体需求**

**文件**: [`../requirements.md`](../requirements.md) - 3.2 节

**内容**:
- 习惯追踪系统在悟道应用中的定位
- 与目标管理、灵感记录的关联
- 非功能需求（性能、安全、兼容性）
- 验收标准

**用途**: 理解习惯模块在整体项目中的角色

---

### 5. **技术架构说明**

**文件**: [`../../technical_architecture_zh.md`](../../technical_architecture_zh.md)

**内容**:
- 混合数据架构策略（目标管理 vs 习惯追踪）
- 习惯模块本地存储优势分析
- 为云端同步预留的扩展性设计
- Flutter + Riverpod + Drift 技术栈详解

**用途**: 理解技术选型和架构决策

---

## 🎯 快速开始指引

### 对于 AI 助手（如 Claude Code）

**推荐阅读顺序**:

1. **PLAN.md** - Phase 2 部分 → 了解任务分解
2. **HABIT_QUICK_START.md** → 20 分钟搭建基础架构
3. **habit_module_requirements.md** → 理解完整设计
4. 按照 PLAN.md 中的任务清单逐步实现

---

### 对于人类开发者

**推荐阅读顺序**:

1. **habit_module_requirements.md** → 理解产品需求和设计思路
2. **technical_architecture_zh.md** → 理解技术选型
3. **HABIT_QUICK_START.md** → 动手搭建 MVP
4. **PLAN.md** Phase 2 → 完整开发指南

---

## 💡 核心概念速览

### 习惯循环三要素

```
暗示（Cue）
    ↓
惯常行为（Routine）
    ↓
奖赏（Reward）
```

**示例**:
- **暗示**: 准备好书包放在一进门就能看到的椅子上
- **惯常行为**: 拿起书包去图书馆
- **奖赏**: 自律的实现让我精神满足

### 习惯替代机制

保持**相同的暗示**和**奖赏**，改变**惯常行为**：

- **暗示**: 无聊，想找刺激
- **旧行为**: 喝奶茶、碳酸饮料 ❌
- **新行为**: 喝冰酸奶或电解质饮料 ✅
- **奖赏**: 享受刺激感

---

## 🛠️ 技术栈（2025-10 最新版本）

| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter | 3.35.5 | UI 框架 |
| Riverpod | 3.0 | 状态管理 |
| Drift | 2.20.0+ | 本地数据库 ORM |
| Freezed | 2.4.6+ | 不可变数据类 |
| UUID | 4.3.3+ | 唯一 ID 生成 |

---

## 📊 当前进度

```
Phase 1: 基础架构    ⏳ 待开始
Phase 2: 核心功能    ⏳ 待开始
Phase 3: 高级功能    ⏳ 待开始
Phase 4: 优化完善    ⏳ 待开始
```

**预计总开发时间**: 4 周（Phase 2 完整实现）

---

## 📁 目录结构预览

```
lib/features/habits/
├── data/
│   ├── models/                # 数据模型（Habit, HabitRecord, DailyPlan, Frontmatter）
│   └── repositories/          # 仓库实现（HabitRepositoryImpl）
├── domain/
│   ├── entities/              # 领域实体（Freezed 不可变类）
│   └── repositories/          # 仓库接口
└── presentation/
    ├── providers/             # Riverpod Providers
    ├── screens/               # 5 个页面（列表/详情/表单/计划/感悟）
    └── widgets/               # 可复用组件（卡片/对话框/热力图/统计卡）
```

---

## ✨ 主要功能

### MVP (Phase 2, 4 周)

- ✅ 创建习惯（正向习惯、习惯替代）
- ✅ 每日打卡（质量评分、执行笔记）
- ✅ 统计分析（连续天数、完成率、本周次数）
- ✅ 日历热力图（GitHub 风格）
- ✅ 次日计划（将暗示转化为行动计划）
- ✅ Frontmatter 习惯感悟（Markdown 编辑器）

### 未来扩展 (Phase 5+)

- 📡 云端同步（Go 后端 + PostgreSQL，可选）
- 🔔 智能提醒（基于暗示触发条件）
- 📈 高级分析（趋势预测、习惯相关性）
- 📤 数据导出（JSON / Markdown / PDF）

---

## 🔧 开发命令

```bash
# 安装依赖
flutter pub get

# 代码生成（Drift + Freezed + Riverpod）
dart run build_runner build --delete-conflicting-outputs

# 监听模式（开发时推荐）
dart run build_runner watch

# 运行应用
flutter run

# 运行测试
flutter test

# 代码格式化
dart format .

# 代码分析
flutter analyze
```

---

## ❓ 常见问题

**Q: 从哪里开始？**
A: 打开 [`HABIT_QUICK_START.md`](./HABIT_QUICK_START.md)，按照步骤操作即可。

**Q: 习惯数据存储在哪里？**
A: Phase 2 完全本地存储（Drift/SQLite），Phase 5+ 可选云端同步。

**Q: 如何理解习惯循环理论？**
A: 阅读 [`habit_module_requirements.md`](../habit_module_requirements.md) 第 1 节。

**Q: 依赖版本冲突怎么办？**
A: 严格使用 `CLAUDE.md` 和本文档中指定的版本。

---

## 📖 相关资源

### 理论基础

- [《习惯的力量》- Charles Duhigg](https://book.douban.com/subject/20507212/)

### 技术文档

- [Flutter 官方文档](https://flutter.dev/docs)
- [Riverpod 3.0 文档](https://riverpod.dev/)
- [Drift 文档](https://drift.simonbinder.eu/)
- [Freezed 文档](https://pub.dev/packages/freezed)

---

## 🎯 下一步行动

### 如果你是新手

1. 阅读 [`HABIT_QUICK_START.md`](./HABIT_QUICK_START.md)
2. 跟着指南完成 MVP（约 20 分钟）
3. 运行并测试应用
4. 查看 [`PLAN.md`](../../PLAN.md) 了解完整开发计划

### 如果你是有经验的开发者

1. 浏览 [`habit_module_requirements.md`](../habit_module_requirements.md) 了解设计
2. 查看 [`technical_architecture_zh.md`](../../technical_architecture_zh.md) 理解架构
3. 直接参考 [`PLAN.md`](../../PLAN.md) Phase 2 开始开发
4. 遇到问题查阅 `HABIT_QUICK_START.md` 中的常见问题

### 如果你是 Claude Code

1. **立即执行**: 打开 [`PLAN.md`](../../PLAN.md) Phase 2 部分
2. **按顺序执行**: Week 1 Task 2.1 开始
3. **参考实现**: 查阅 [`habit_module_requirements.md`](../habit_module_requirements.md) 中的代码示例
4. **验证结果**: 确保每个功能都能正常工作

---

**最后更新**: 2025-10-04
**文档版本**: v2.0 (简化版)

**现在就开始吧！** 🚀
打开 [`HABIT_QUICK_START.md`](./HABIT_QUICK_START.md) 开始你的习惯追踪之旅！
