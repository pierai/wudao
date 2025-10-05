# 悟道 - 开发计划

## 总体路线图

```
Phase 1: 人生目标管理 MVP
    ↓
Phase 2: 习惯追踪系统    ← 当前阶段 (Week 1-2 已完成)
    ↓
Phase 3: 灵感记录与反思
    ↓
Phase 4: 知识库与搜索
    ↓
Phase 5: 高级功能（数据分析、导出等）
```

---

## Phase 1: 人生目标管理 MVP (4-6 周)

**目标**: 实现基于《高效能人士的七个习惯》的层级目标管理系统

### 已完成 ✅

- [x] 项目技术架构设计
- [x] 技术栈选型和依赖确认
- [x] Claude Code Agent 配置
- [x] **Task 1.1**: Flutter 项目初始化
  - [x] 创建项目骨架
  - [x] 配置 `pubspec.yaml` 依赖
  - [x] 设置目录结构（feature-first）
  - [x] 配置 Riverpod ProviderScope
- [x] **Task 1.2**: 创建 iOS 风格底部导航
  - [x] 使用 liquid_glass_bottom_bar 实现玻璃效果导航栏
  - [x] 创建 HomeScreen 主导航页面
  - [x] 添加 4 个 Tab（目标/习惯/灵感/我的）
  - [x] 实现页面切换状态管理（Riverpod）
  - [x] 创建各功能模块占位页面

- [x] **Task 1.3**: Go 后端项目初始化
  - [x] 创建标准项目结构 (cmd/internal/pkg)
  - [x] 配置 Gin 框架
  - [x] 设置环境变量加载 (godotenv)
  - [x] 实现健康检查端点 `/health`
- [x] **Task 1.4**: PostgreSQL 数据库设置
  - [x] 创建 Docker Compose 配置
  - [x] 安装 ltree 扩展
  - [x] 设计目标表结构
  - [x] 编写初始化迁移脚本

- [x] **Task 1.5**: 开发环境配置和调试
  - [x] 配置 macOS 应用网络权限（entitlements）
  - [x] 解决 VS Code 调试 VM Service 启动问题
  - [x] 配置 FVM Flutter SDK 路径（.fvm/flutter_sdk）
  - [x] 验证 Flutter 应用与 Go 后端连接
  - [x] 升级 Riverpod 到 3.0 版本
  - [x] 创建 API 客户端基础架构（Dio + Interceptors）
  - [x] 实现健康检查端点测试

### 进行中 🔄

#### Week 2: 目标数据模型与存储

- [ ] **Task 2.1**: 定义 Goal 数据模型
  - [ ] 创建 Freezed Goal 模型
  - [ ] 添加 JSON 序列化
  - [ ] 定义目标状态枚举（active/completed/archived）
  - [ ] 定义优先级枚举（1-5）
  - **负责**: @flutter_architect
  - **预计时间**: 2 小时

- [ ] **Task 2.2**: Drift 本地数据库
  - [ ] 定义 GoalsTable
  - [ ] 创建 GoalDao
  - [ ] 实现 CRUD 方法
  - [ ] 添加层级路径查询
  - **负责**: @flutter_architect
  - **预计时间**: 4 小时

- [ ] **Task 2.3**: PostgreSQL 目标表实现
  - [ ] 创建 goals 表（ltree path）
  - [ ] 添加索引（GIST on path）
  - [ ] 编写示例查询（子树、祖先）
  - [ ] 测试层级查询性能
  - **负责**: @database_designer
  - **预计时间**: 3 小时

- [ ] **Task 2.4**: Go Repository 层
  - [ ] 定义 GoalRepository 接口
  - [ ] 实现 PostgresGoalRepository
  - [ ] 使用 pgx 实现 CRUD
  - [ ] 处理 ltree 路径操作
  - **负责**: @go_backend
  - **预计时间**: 4 小时

#### Week 3: 目标管理 API

- [ ] **Task 3.1**: Go Service 层
  - [ ] 创建 GoalService
  - [ ] 实现业务逻辑（路径生成、验证）
  - [ ] 添加进度计算逻辑
  - [ ] 编写单元测试
  - **负责**: @go_backend
  - **预计时间**: 4 小时

- [ ] **Task 3.2**: RESTful API 端点
  - [ ] `GET /api/v1/goals` - 获取目标列表
  - [ ] `GET /api/v1/goals/:id` - 获取单个目标
  - [ ] `POST /api/v1/goals` - 创建目标
  - [ ] `PUT /api/v1/goals/:id` - 更新目标
  - [ ] `DELETE /api/v1/goals/:id` - 删除目标
  - [ ] `GET /api/v1/goals/:id/children` - 获取子目标
  - **负责**: @go_backend
  - **预计时间**: 5 小时

- [ ] **Task 3.3**: Swagger 文档生成
  - [ ] 添加 swaggo 注解
  - [ ] 生成 Swagger JSON
  - [ ] 配置 Swagger UI
  - [ ] 测试所有端点
  - **负责**: @go_backend
  - **预计时间**: 2 小时

- [ ] **Task 3.4**: 中间件配置
  - [ ] CORS 中间件
  - [ ] 日志中间件
  - [ ] API Key 认证中间件
  - [ ] 速率限制中间件
  - **负责**: @go_backend
  - **预计时间**: 3 小时

#### Week 4: Flutter UI 实现

- [ ] **Task 4.1**: 目标列表页面
  - [ ] 创建 GoalsListScreen
  - [ ] 使用 CupertinoListSection 展示层级
  - [ ] 实现下拉刷新
  - [ ] 添加搜索功能
  - [ ] 支持按状态筛选
  - **负责**: @flutter_architect
  - **预计时间**: 6 小时

- [ ] **Task 4.2**: 目标详情页面
  - [ ] 创建 GoalDetailScreen
  - [ ] 显示目标完整信息
  - [ ] 展示子目标列表
  - [ ] 显示进度条
  - [ ] 添加编辑/删除按钮
  - **负责**: @flutter_architect
  - **预计时间**: 4 小时

- [ ] **Task 4.3**: 目标创建/编辑表单
  - [ ] 创建 GoalFormScreen
  - [ ] 实现 CupertinoTextField 表单
  - [ ] 父目标选择器（层级树）
  - [ ] 优先级选择器
  - [ ] 日期选择器
  - [ ] 表单验证
  - **负责**: @flutter_architect
  - **预计时间**: 5 小时

- [ ] **Task 4.4**: Riverpod 状态管理
  - [ ] 创建 GoalsNotifier
  - [ ] 实现 AsyncNotifierProvider
  - [ ] 处理加载/错误/数据状态
  - [ ] 添加乐观更新
  - **负责**: @flutter_architect
  - **预计时间**: 4 小时

#### Week 5: 前后端集成

- [ ] **Task 5.1**: Dio API Client 配置
  - [ ] 配置 BaseOptions
  - [ ] 添加 LogInterceptor
  - [ ] 添加 AuthInterceptor
  - [ ] 添加 RetryInterceptor
  - **负责**: @integration_specialist
  - **预计时间**: 3 小时

- [ ] **Task 5.2**: GoalRepository 实现
  - [ ] 创建 ApiGoalRepository
  - [ ] 实现所有 CRUD 方法
  - [ ] 错误处理和映射
  - [ ] 超时和重试逻辑
  - **负责**: @integration_specialist
  - **预计时间**: 4 小时

- [ ] **Task 5.3**: 离线优先同步
  - [ ] 实现缓存策略
  - [ ] 创建 PendingActionsQueue
  - [ ] 网络状态监听
  - [ ] 自动后台同步
  - **负责**: @integration_specialist
  - **预计时间**: 6 小时

- [ ] **Task 5.4**: 集成测试
  - [ ] 测试创建目标流程
  - [ ] 测试离线创建+在线同步
  - [ ] 测试网络错误处理
  - [ ] 测试冲突解决
  - **负责**: @integration_specialist
  - **预计时间**: 4 小时

#### Week 6: 优化与完善

- [ ] **Task 6.1**: 性能优化
  - [ ] Widget 重建优化
  - [ ] 列表滚动性能
  - [ ] 图片/缓存优化
  - [ ] 数据库查询优化
  - **预计时间**: 4 小时

- [ ] **Task 6.2**: UI 细节打磨
  - [ ] 过渡动画
  - [ ] 触觉反馈
  - [ ] 空状态设计
  - [ ] 错误状态设计
  - **预计时间**: 4 小时

- [ ] **Task 6.3**: Docker 部署配置
  - [ ] 编写 Dockerfile
  - [ ] 配置 docker-compose.yml
  - [ ] 环境变量配置
  - [ ] 健康检查
  - **负责**: @go_backend
  - **预计时间**: 3 小时

- [ ] **Task 6.4**: 文档完善
  - [ ] API 文档完善
  - [ ] 部署指南
  - [ ] 用户手册（初稿）
  - [ ] 更新 CLAUDE.md
  - **预计时间**: 3 小时

### Phase 1 验收标准 ✓

- [ ] 用户可以创建 5 层层级目标
- [ ] 目标支持编辑、删除、归档
- [ ] 进度自动计算和展示
- [ ] 离线创建目标，在线自动同步
- [ ] iOS 风格 UI，流畅的动画
- [ ] 后端 API 有完整 Swagger 文档
- [ ] Docker Compose 一键启动
- [ ] 代码覆盖率 > 60%

---

## Phase 2: 习惯追踪系统 (4 周)

**目标**: 基于《习惯的力量》实现习惯追踪和触发机制管理

**技术策略**:

- Phase 2: 纯本地 Drift 存储（快速 MVP）
- Phase 5+: 可选云端同步（Go 后端 + PostgreSQL）

### Week 1: 数据层与领域层 (基础架构) ✅

#### Task 2.1: Drift 数据库表设计 ✅

- [x] 创建 `lib/core/database/tables/habits_table.dart`
  - 习惯循环三要素（暗示 cue、惯常行为 routine、奖赏 reward）
  - 习惯类型（正向习惯 POSITIVE、习惯替代 REPLACEMENT）
  - 软删除支持
  - **修复**: CHECK 约束使用下划线命名 `old_routine`
- [x] 创建 `lib/core/database/tables/habit_records_table.dart`
  - 执行记录（时间戳、质量评分 1-5、笔记）
  - 支持补打卡标记 isBackfilled
- [x] 创建 `lib/core/database/tables/daily_plans_table.dart`
  - 次日计划（关联习惯、暗示任务、优先级）
  - 计划完成状态与打卡记录关联
- [x] 创建 `lib/core/database/tables/habit_frontmatters_table.dart`
  - 习惯感悟（Markdown 内容、标签系统）
- [x] 运行代码生成: `dart run build_runner build --delete-conflicting-outputs`
- **负责**: @flutter_architect
- **实际时间**: 4 小时

#### Task 2.2: DAO 层实现 ✅

- [x] 实现 `lib/core/database/daos/habit_dao.dart`
  - watchActiveHabits(), getHabitById(), insertHabit(), updateHabit(), softDeleteHabit()
  - 按分类筛选、搜索功能
- [x] 实现 `lib/core/database/daos/habit_record_dao.dart`
  - getRecordsByHabitId(), hasRecordOnDate(), insertRecord()
  - 日期范围查询支持
- [x] 实现 `lib/core/database/daos/daily_plan_dao.dart`
  - watchPlansByDate(), insertPlans(), completePlan()
- [x] 实现 `lib/core/database/daos/frontmatter_dao.dart`
  - watchAllFrontmatters(), getLatestFrontmatter()
- [x] 更新 `lib/core/database/app_database.dart` 注册所有表和 DAO
- **负责**: @flutter_architect
- **实际时间**: 5 小时

#### Task 2.3: 领域实体定义（Freezed） ✅

- [x] 定义 `lib/features/habits/domain/entities/habit.dart`
  - Habit 实体 + HabitType 枚举
- [x] 定义 `lib/features/habits/domain/entities/habit_record.dart`
- [x] 定义 `lib/features/habits/domain/entities/daily_plan.dart`
- [x] 定义 `lib/features/habits/domain/entities/habit_frontmatter.dart`
- [x] 定义 `lib/features/habits/domain/entities/habit_stats.dart`
  - 连续天数、总执行次数、完成率、最佳连续记录
- [x] 运行 Freezed 代码生成
- **负责**: @flutter_architect
- **实际时间**: 3 小时

#### Task 2.4: Repository 层实现 ✅

- [x] 定义 `lib/features/habits/domain/repositories/habit_repository.dart` 接口
  - 习惯 CRUD、执行记录、统计信息、次日计划、Frontmatter
- [x] 实现 `lib/features/habits/data/repositories/habit_repository_impl.dart`
  - 完整的业务逻辑实现
  - 连续天数计算算法（_calculateCurrentStreak）
  - 完成率计算算法（_calculateCompletionRate）
- [x] 创建数据模型转换器
  - `lib/features/habits/data/models/habit_model.dart`（toEntity/toData 扩展）
  - 其他实体的转换器
- **负责**: @flutter_architect
- **实际时间**: 6 小时

### Week 2: 核心 UI 实现 (基础功能) ✅

#### Task 2.5: Riverpod Providers 配置 ✅

- [x] 创建 `lib/features/habits/presentation/providers/habit_provider.dart`
  - databaseProvider、habitRepositoryProvider
  - activeHabitsProvider (StreamProvider)
  - habitStatsProvider (FutureProvider.family)
  - hasTodayRecordProvider (FutureProvider.family)
  - searchHabitsProvider (FutureProvider.family)
- [x] 更新 `lib/main.dart` 添加 ProviderScope
- [x] 更新 `lib/app.dart` 使用 ConsumerWidget
- **负责**: @flutter_architect
- **实际时间**: 2 小时

#### Task 2.6: 习惯列表页面 ✅

- [x] 实现 `lib/features/habits/presentation/screens/habits_screen.dart`
  - CupertinoPageScaffold + 导航栏（修复 Hero 标签冲突）
  - StreamProvider 监听习惯列表
  - 空状态设计（精美插图 + 引导文案）
  - 下拉刷新支持
  - 搜索功能（CupertinoSearchTextField）
- [x] 创建 `lib/features/habits/presentation/widgets/habit_card.dart`
  - 显示习惯名称、暗示、连续天数、完成率
  - 习惯类型徽章（"正向习惯"/"习惯替代"）
  - 快速打卡按钮（已打卡显示 ✓）
  - **优化交互**: 点击卡片进入编辑、左滑删除（Dismissible）
  - 修复布局约束问题（Column mainAxisSize）
- **负责**: @flutter_architect
- **实际时间**: 7 小时

#### Task 2.7: 创建/编辑习惯表单 ✅

- [x] 实现 `lib/features/habits/presentation/screens/habit_form_screen.dart`
  - CupertinoSegmentedControl 选择习惯类型
  - 表单字段：名称、暗示、惯常行为、奖赏、分类、备注
  - 习惯替代模式：额外显示"原惯常行为"字段
  - 表单验证（必填项检查）
  - 保存逻辑（创建/更新）
- [x] 添加提示文案（💡 暗示越具体，越容易触发）
- **负责**: @flutter_architect
- **实际时间**: 5 小时

#### Task 2.8: 打卡对话框 ✅

- [x] 创建 `lib/features/habits/presentation/widgets/check_in_dialog.dart`
  - CupertinoAlertDialog 样式
  - 执行时间选择（CupertinoDatePicker）
  - 执行质量星级选择（1-5 星）
  - 执行笔记输入框（可选）
  - 打卡成功动画反馈
  - 自动刷新 Provider（invalidate habitStatsProvider）
- **负责**: @flutter_architect
- **实际时间**: 4 小时

---

### Week 2+ 扩展：核心习惯（Keystone Habits）功能 ✅

> 基于《习惯的力量》（The Power of Habit）书中的核心习惯理论

#### 已实现：方案 A - 简单标记方式 ✅

**当前实现** (Phase 2, Week 2):

- ✅ 数据库字段：`is_keystone` (boolean)
- ✅ 实体支持：Habit 实体添加 `isKeystone` 字段
- ✅ UI 表单：创建/编辑习惯时可切换核心习惯开关
- ✅ UI 展示：习惯卡片显示 "💎 核心习惯" 橙色徽章
- ✅ 筛选功能：可按"全部/仅核心/仅普通"筛选习惯列表

**设计理念**:

- 用户手动标记哪些习惯是核心习惯
- 通过视觉标识（💎 徽章）提示用户重点关注
- 简单直观，无学习成本

**适用场景**:

- MVP 阶段快速验证核心习惯概念
- 无需复杂数据建模
- 用户自行判断哪些习惯对自己最重要

#### 未来规划：方案 B - 关联影响方式 (Phase 3 或 Phase 4)

**核心概念**:

核心习惯（Keystone Habit）不仅本身重要，更重要的是它会**引发连锁反应**，带动其他习惯的形成。

**示例**:

- 核心习惯："每天运动 30 分钟"
  - → 影响习惯："健康饮食"（运动后更关注营养）
  - → 影响习惯："早睡早起"（运动消耗体力，促进睡眠）
  - → 影响习惯："提高工作效率"（运动改善精神状态）

**功能设计**:

##### 1. 数据模型扩展

**新增表**: `habit_dependencies`（习惯依赖关系表）

```sql
CREATE TABLE habit_dependencies (
  id TEXT PRIMARY KEY,
  keystone_habit_id TEXT NOT NULL,        -- 核心习惯 ID
  influenced_habit_id TEXT NOT NULL,      -- 被影响的习惯 ID
  influence_type TEXT NOT NULL,           -- 影响类型: POSITIVE(促进), NEGATIVE(抑制)
  influence_strength INTEGER DEFAULT 3,   -- 影响强度: 1-5
  description TEXT,                       -- 影响关系描述
  created_at TIMESTAMP NOT NULL,
  FOREIGN KEY (keystone_habit_id) REFERENCES habits(id),
  FOREIGN KEY (influenced_habit_id) REFERENCES habits(id),
  CHECK (keystone_habit_id != influenced_habit_id), -- 防止自引用
  UNIQUE (keystone_habit_id, influenced_habit_id)   -- 防止重复关系
);
```

##### 2. 核心功能实现

- [ ] **习惯关联管理**
  - 为核心习惯添加"影响的习惯"列表
  - 支持添加/删除依赖关系
  - 设置影响类型（促进/抑制）和强度

- [ ] **可视化影响网络**
  - 使用力导向图（Force-Directed Graph）展示习惯关系网
  - 节点大小表示习惯的影响力（被引用次数）
  - 连线粗细表示影响强度
  - 颜色区分：绿色=促进、红色=抑制

- [ ] **连锁效应统计**
  - 核心习惯坚持时，同步显示"影响的习惯"执行率变化
  - 计算连锁效应系数：`(被影响习惯平均完成率提升) / (核心习惯完成天数)`
  - 生成影响力报告："运动 30 天后，健康饮食完成率从 60% 提升至 85%"

- [ ] **智能推荐**
  - 基于已有习惯，推荐可能的核心习惯
  - 例如：检测到"早起"和"冥想"同时出现，推荐"每晚 10 点关机"作为核心习惯

##### 3. UI/UX 设计

- [ ] 习惯详情页新增"影响关系"Tab
  - 显示：该习惯影响的其他习惯（作为核心习惯）
  - 显示：影响该习惯的核心习惯（作为被影响者）

- [ ] 核心习惯详情页
  - 影响网络可视化图表
  - 被影响习惯的执行情况对比（核心习惯坚持前后）
  - "添加影响关系"按钮

- [ ] 习惯创建向导优化
  - 创建新习惯时，询问："这个习惯是否依赖其他习惯？"
  - 自动建议可能的核心习惯关联

##### 4. 技术实现要点

- **数据层**: 新增 `HabitDependencyDao` 和 `habit_dependency` 实体
- **Repository 层**: 扩展方法获取依赖关系图
- **Provider 层**: 提供影响网络数据流
- **可视化**: 使用 `fl_chart` 或 `graphview` 包实现力导向图

##### 5. 验收标准

- [ ] 可以为核心习惯添加最多 10 个影响关系
- [ ] 影响网络图渲染流畅（支持拖拽节点）
- [ ] 连锁效应统计准确（基于实际打卡数据）
- [ ] 不能创建循环依赖（A → B → C → A）

#### 方案对比

| 特性 | 方案 A（简单标记）| 方案 B（关联影响）|
|------|------------------|------------------|
| **实现复杂度** | ⭐ 低 | ⭐⭐⭐⭐ 高 |
| **数据建模** | 单表字段 | 多表关系 |
| **用户学习成本** | 0（标记即可）| 中（需理解关联概念）|
| **理论还原度** | 中 | 高（完整体现连锁反应）|
| **统计价值** | 低（仅标识）| 高（量化影响）|
| **适用阶段** | MVP 验证 | 成熟产品 |
| **维护成本** | 低 | 高（图算法、数据一致性）|

#### 实施路线图

**Phase 2** (当前):

- ✅ 实现方案 A（简单标记）
- ✅ 收集用户反馈，验证核心习惯概念有效性

**Phase 3** (可选):

- 如果方案 A 验证成功，开始设计方案 B 原型
- 用户调研：是否需要关联功能

**Phase 4** (未来):

- 实现方案 B 完整功能
- 提供数据迁移工具（方案 A → 方案 B）

**参考资料**:

- 《习惯的力量》- Charles Duhigg
- 核心习惯理论：小改变如何引发大变革

---

### Week 3: 高级功能 (统计与可视化)

#### Task 2.9: 习惯详情页面 ✅

- [x] 实现 `lib/features/habits/presentation/screens/habit_detail_screen.dart`
  - 习惯循环三要素展示（卡片式布局）
  - 执行统计卡片（连续天数、总次数、本周次数、完成率）
  - 执行记录列表（时间、质量星级、笔记）
  - 编辑/删除按钮
- [x] 创建 `lib/features/habits/presentation/widgets/habit_stats_card.dart`
  - 4 格统计面板
  - 数据自动更新
- [x] 更新 HabitCard：点击卡片进入详情页（替代原来的编辑功能）
- **负责**: @flutter_architect
- **实际时间**: 3 小时

#### Task 2.10: 统计计算逻辑完善 ✅

- [x] 优化 Repository 中的统计算法
  - 连续天数计算（支持"今天或昨天"逻辑）
  - 本周执行次数（周一为起始）
  - 完成率计算（自首次记录以来）
  - 最佳连续记录计算
- [x] 验证统计算法正确性（代码审查）
- **负责**: @flutter_architect
- **实际时间**: 1 小时

#### Task 2.11: 日历热力图组件 ✅

- [x] 创建 `lib/features/habits/presentation/widgets/habit_calendar_heatmap.dart`
  - GitHub 风格热力图（最近 6 个月）
  - 绿色渐变表示质量（1-5 星 → 20%-100% 透明度）
  - 点击日期显示当天打卡详情（时间 + 质量）
  - 水平滚动查看历史数据
  - 图例说明（少 → 多）
- [x] 集成到习惯详情页
- **负责**: @flutter_architect
- **实际时间**: 2 小时

#### Task 2.12: 次日计划功能 ✅

- [x] 实现 `lib/features/habits/presentation/screens/daily_plan_screen.dart`
  - 显示计划列表（今日/明日切换，按优先级和完成状态排序）
  - 计划完成勾选（点击整个卡片）
  - 关联习惯显示（异步加载习惯名称）
  - 左滑删除计划
- [x] 创建 `lib/features/habits/presentation/widgets/plan_generator_dialog.dart`
  - 习惯选择对话框（多选，核心习惯优先级默认为高）
  - 为每个习惯设置建议时间（时间选择器）
  - 设置优先级（低/中/高）
  - 批量生成次日计划（将暗示作为任务）
- [x] 实现计划完成到打卡的关联逻辑
  - 标记完成时弹出确认："暗示已完成，是否执行惯常行为并打卡？"
  - 两个选项：仅标记完成 / 完成并打卡
  - 预留 recordId 关联字段（TODO: 集成打卡对话框）
- **负责**: @flutter_architect
- **实际时间**: 4 小时

### Week 4: 完善与测试 (打磨体验)

#### Task 2.13: Frontmatter 习惯感悟 ✅

- [x] 实现 `lib/features/habits/presentation/screens/frontmatter_screen.dart`
  - Markdown 编辑器（使用 flutter_markdown）
  - YAML frontmatter 编辑（title, created, updated, tags）
  - 预览模式 / 编辑模式切换
  - 自动保存草稿
- [x] 标签系统
  - 标签选择器
  - 按标签筛选
- [x] 时间线展示
  - 按更新时间排序
  - 与习惯关联显示
- **负责**: @flutter_architect
- **实际时间**: 5 小时

#### Task 2.14: UI/UX 优化 ✅

- [x] 添加页面切换动画（CupertinoPageRoute）
- [x] 打卡成功动画（✓ 图标放大 + 震动反馈）
- [x] 成就通知（连续 7 天、30 天等里程碑）
- [x] 空状态优化（精美插图）
- [x] 加载状态优化（CupertinoActivityIndicator）
- [x] 错误状态设计（友好提示）
- [x] 修复次日计划页面加载问题
- [x] 修复各类 UI bug
- **负责**: @flutter_architect
- **实际时间**: 5 小时

#### Task 2.15: 路由配置 ✅

- [x] 创建 `lib/routing/app_router.dart`
  - /habits - 习惯列表
  - /habits/new - 创建习惯
  - /habits/detail - 习惯详情（参数：habitId）
  - /habits/edit - 编辑习惯（参数：habitId）
  - /habits/daily-plan - 次日计划
  - /habits/frontmatter - 习惯感悟列表
  - /habits/frontmatter/new - 创建感悟
  - /habits/frontmatter/edit - 编辑感悟（参数：frontmatter）
  - /habits/export - 导出数据
  - /habits/import - 导入数据
- [x] 集成到 CupertinoApp（onGenerateRoute、onUnknownRoute）
- [x] 更新所有导航调用使用路由
- **负责**: @flutter_architect
- **实际时间**: 1.5 小时

#### Task 2.16: 测试与文档

- [ ] 编写单元测试
  - 实体测试（Habit, HabitRecord, HabitStats）
  - Repository 测试（统计计算逻辑）
- [ ] 编写 Widget 测试
  - HabitCard 组件测试
  - CheckInDialog 测试
- [ ] 编写集成测试
  - 创建习惯 → 打卡 → 查看统计 完整流程
- [ ] 更新用户手册
- **负责**: @flutter_architect
- **预计时间**: 5 小时

#### Task 2.17: 数据导入导出功能（跨设备同步）✅

> **核心场景**: iPhone 离线录入 → 导出 → macOS 导入，实现跨设备数据同步

- [x] **数据导出功能**
  - [x] 实现 `lib/features/habits/data/services/data_export_service.dart`
    - **JSON 格式**（跨设备同步首选）
      - 完整数据结构：习惯、记录、计划、Frontmatter
      - 设备标识：记录导出来源设备（iPhone/macOS）
      - 时间戳：精确到毫秒，用于冲突解决
    - **CSV 格式**（数据分析用途）
      - 每个实体类型单独文件（habits.csv, records.csv 等）
    - **Markdown 格式**（可读报告）
      - 习惯总结报告，包含统计图表
  - [x] 创建 `lib/features/habits/presentation/screens/export_screen.dart`
    - 选择导出格式（JSON 推荐用于同步）
    - 选择导出范围：
      - 全量导出（所有数据）
      - 增量导出（仅最近 N 天的数据）
      - 自定义导出（选择特定习惯）
    - 导出选项：
      - 包含已删除数据（用于恢复）
      - 包含 Frontmatter 附件
    - 文件命名：`wudao_backup_20251005_143022.json`
    - 快捷分享：
      - **AirDrop**（iPhone → macOS 最快）
      - iCloud Drive（自动同步到其他设备）
      - 邮件/其他应用

- [x] **数据导入功能（智能合并）**
  - [x] 实现 `lib/features/habits/data/services/data_import_service.dart`
    - **版本兼容性检查**
      - 检查导出文件版本（支持向前兼容）
      - 数据结构迁移（如果版本不匹配）
    - **数据冲突检测**
      - ID 冲突：同一习惯在两设备都存在
      - 内容冲突：同一习惯内容不同
      - 记录冲突：同一天同一习惯多次打卡
    - **智能合并策略**
      - **按更新时间**：`updated_at` 较新的覆盖旧的
      - **按设备优先级**：用户指定 iPhone/macOS 优先
      - **手动选择**：逐项确认冲突数据
      - **双向合并**：
        - 习惯：更新时间晚的优先
        - 打卡记录：按日期去重（取最新质量评分）
        - 计划：合并两设备的计划（去重）
        - Frontmatter：按创建时间合并
  - [x] 创建 `lib/features/habits/presentation/screens/import_screen.dart`
    - **Step 1: 文件选择**
      - 支持从文件系统选择（file_picker）
      - 支持从 iCloud Drive 选择
      - 文件格式验证（仅 .json）
    - **Step 2: 导入预览**
      - 显示数据摘要：
        - 将导入 X 个习惯
        - 将导入 Y 条打卡记录
        - 检测到 Z 个冲突
      - 冲突详情列表（可展开查看）
    - **Step 3: 冲突解决**
      - 全局策略选择：
        - "保留新数据"（导入文件优先）
        - "保留旧数据"（当前设备优先）
        - "智能合并"（按更新时间）
        - "手动选择"（逐项确认）
      - 冲突项对比 UI：
        - 左侧：当前设备数据
        - 右侧：导入文件数据
        - 按钮：保留左侧/保留右侧/合并
    - **Step 4: 执行导入**
      - 进度条显示（习惯 → 记录 → 计划 → Frontmatter）
      - 导入日志（实时显示操作）
    - **Step 5: 结果报告**
      - ✅ 成功导入 X 项
      - ⏭️ 跳过 Y 项（无变化）
      - ⚠️ 合并 Z 项（冲突已解决）
      - ❌ 失败 N 项（错误详情）
  - [x] **数据备份与回滚**
    - 导入前自动备份：`backup_before_import_20251005.json`
    - 导入失败自动回滚（事务机制）
    - 备份保留策略：最多 5 个备份文件

- [x] **设置页面集成**
  - [x] 在设置页面添加"数据管理"分组
    - "导出数据"按钮 → 跳转到导出页面
    - "导入数据"按钮 → 跳转到导入页面
    - "查看备份历史"（显示最近 5 个备份）
    - "自动备份"开关（定期备份到 iCloud Drive）
    - "清空所有数据"按钮（危险操作，需二次确认）

- [x] **技术实现要点**
  - **依赖包**：
    - `path_provider` ^2.1.5 - 获取应用文档目录
    - `file_picker` ^8.1.4 - 选择导入/导出文件
    - `share_plus` ^10.1.3 - 分享导出文件（AirDrop/邮件）
    - `csv` ^6.0.0 - CSV 格式处理
    - `device_info_plus` ^11.2.0 - 获取设备信息
  - **JSON 序列化**：
    - 使用现有的 Freezed 模型 `toJson()`/`fromJson()`
    - 处理 DateTime 时间戳（ISO 8601 格式）
    - 处理嵌套关系（习惯 → 记录）
  - **事务机制**：
    - 使用 Drift `transaction()` 确保数据一致性
    - 导入失败时完整回滚
  - **设备标识**：
    - 使用 `device_info_plus` 获取设备信息
    - 记录导出来源：iPhone 15 Pro / MacBook Pro

- [x] **数据格式规范**
  - **JSON 格式示例**：
    ```json
    {
      "version": "1.0.0",
      "app_version": "0.1.0",
      "exported_at": "2025-10-05T14:30:22.123Z",
      "exported_from": {
        "device_type": "iPhone",
        "device_model": "iPhone 15 Pro",
        "os_version": "iOS 17.0"
      },
      "metadata": {
        "total_habits": 10,
        "total_records": 150,
        "total_plans": 20,
        "total_frontmatters": 5
      },
      "data": {
        "habits": [
          {
            "id": "uuid-1",
            "name": "晨跑",
            "cue": "早上6点闹钟响",
            "routine": "跑步30分钟",
            "reward": "记录跑步距离",
            "category": "运动",
            "is_keystone": true,
            "created_at": "2025-10-01T08:00:00Z",
            "updated_at": "2025-10-05T14:20:00Z"
          }
        ],
        "records": [...],
        "plans": [...],
        "frontmatters": [...]
      }
    }
    ```
  - **CSV 格式**：每个实体类型单独文件
    - `habits.csv`：习惯列表
    - `records.csv`：打卡记录
    - `plans.csv`：次日计划
  - **Markdown 格式**：习惯总结报告（仅导出，不支持导入）

- **负责**: @flutter_architect
- **实际时间**: 8 小时

**验收标准（跨设备同步场景）**:
- [x] ✅ iPhone 导出 JSON → AirDrop → macOS 导入成功
- [x] ✅ 可以智能合并数据（不丢失任何一方的数据）
- [x] ✅ 冲突检测准确（同一习惯在两设备都修改）
- [x] ✅ 冲突解决 UI 清晰（可对比两侧数据）
- [x] ✅ 导入失败自动回滚（数据不损坏）
- [x] ✅ 支持增量导出（只导出最近 7 天数据）
- [x] ✅ 备份机制可靠（最多保留 5 个备份）
- [x] ✅ macOS → iPhone 反向同步也正常工作

**推荐同步流程**:
1. **首次同步**: iPhone 全量导出 → macOS 导入（选择"保留新数据"）
2. **日常同步**: iPhone 增量导出（最近 7 天）→ macOS 导入（选择"智能合并"）
3. **双向同步**:
   - iPhone 和 macOS 都导出各自数据
   - 手动选择最新的文件作为主数据源
   - 另一设备导入时选择"智能合并"

### Week 5: 次日计划交互优化（核心体验提升）

> **需求文档**: [`docs/requirements/daily_plan_interaction_requirements.md`](../docs/requirements/daily_plan_interaction_requirements.md)

#### Task 2.22: 次日计划状态机重构 ✨ ✅

**背景**: 当前暗示完成和习惯打卡边界不清晰,需要明确状态流转规则

**核心改进**:
- 引入状态机模型: `pending` → `cueCompleted` → `checkedIn` / `skipped`
- 暗示完成 ≠ 习惯打卡,状态独立管理
- 习惯列表和次日计划双向同步

**子任务**:

##### Phase 1: 数据层改造 (2 小时) ✅

- [x] **实体层修改**
  - [x] `DailyPlan` 新增字段: `status`, `recordId`, `cueCompletedAt`, `checkedInAt`
  - [x] `HabitRecord` 新增字段: `source`, `planId`
  - [x] 定义枚举: `PlanCompletionStatus`, `RecordSource`
  - [x] 运行 Freezed 代码生成

- [x] **数据库层修改**
  - [x] 修改 `DailyPlansTable`: 新增 4 个字段
  - [x] 修改 `HabitRecordsTable`: 新增 2 个字段
  - [x] 编写迁移脚本 `migration_v2_plan_status.dart`
  - [x] 更新数据库版本号(v1 → v2)
  - [x] 测试迁移脚本(旧数据兼容性)

##### Phase 2: 业务逻辑实现 (3 小时) ✅

- [x] **Repository 接口扩展**
  - [x] 新增方法: `markCueCompleted()`, `markCueIncomplete()`
  - [x] 新增方法: `markPlanCheckedIn()`, `markPlanSkipped()`
  - [x] 新增方法: `cancelCheckIn()`, `hasTodayRecord()`, `getTodayRecord()`
  - [x] 新增方法: `syncPlanStatusAfterCheckIn()`

- [x] **状态流转逻辑**
  - [x] 实现 pending → cueCompleted 流程
  - [x] 实现 cueCompleted → checkedIn 流程(关联 recordId)
  - [x] 实现 pending → skipped 流程(习惯列表直接打卡)
  - [x] 实现取消操作(checkedIn → cueCompleted)

- [x] **双向同步逻辑**
  - [x] 习惯列表打卡 → 计划自动标记为 skipped
  - [x] 计划打卡 → 习惯列表显示"已打卡"
  - [x] 取消打卡 → 双向状态恢复

- [x] **防重复打卡**
  - [x] 检查今日是否已打卡
  - [x] 已打卡状态禁止再次打卡
  - [x] 清晰的错误提示

- [ ] **单元测试**
  - [ ] 测试状态流转规则
  - [ ] 测试同步逻辑
  - [ ] 测试防重复打卡

##### Phase 3: UI 层重构 (3 小时) ✅

- [x] **DailyPlanScreen 交互优化**
  - [x] **移除**: 二选一对话框("仅标记完成"/"完成并打卡")
  - [x] **新增**: 点击卡片 → 直接标记暗示完成(pending → cueCompleted)
  - [x] **新增**: 暗示完成后显示"打卡"按钮
  - [x] **新增**: 点击"打卡"按钮 → 弹出打卡对话框
  - [x] **新增**: 明日计划 Tab 只读(卡片置灰,不可操作)

- [x] **PlanCard 组件重构**
  - [x] 状态指示器重构:
    - pending: 空心圆圈 ○
    - cueCompleted: 绿色勾 ✓ + "打卡"按钮
    - checkedIn: 绿色勾 ✓ + "已打卡"徽章 + 星级显示
    - skipped: 删除线 + "已跳过"徽章
  - [x] 条件渲染"打卡"按钮(仅 cueCompleted 状态)
  - [x] 点击卡片标记/取消暗示完成
  - [x] 明日计划状态: 置灰显示,点击无响应

- [x] **HabitCard 组件优化**
  - [x] 新增 Provider: `todayRecordProvider` (监听今日打卡记录)
  - [x] 根据打卡状态动态显示按钮:
    - 未打卡: "打卡"按钮(激活)
    - 已打卡: "已打卡"徽章(禁用) + 星级显示
  - [x] 打卡成功后自动刷新状态
  - [x] 尝试重复打卡弹出提示: "今日已打卡"

##### Phase 4: 测试与优化 (2 小时)

- [ ] **Widget 测试**
  - [ ] PlanCard 组件: 4 种状态渲染正确
  - [ ] HabitCard 组件: 打卡状态显示正确

- [ ] **集成测试**
  - [ ] 场景 1: 按计划完整执行(pending → cueCompleted → checkedIn)
  - [ ] 场景 2: 仅完成暗示,稍后补打卡
  - [ ] 场景 3: 跳过计划,直接在习惯列表打卡(→ skipped)
  - [ ] 场景 4: 尝试重复打卡(被阻止)
  - [ ] 场景 5: 取消打卡(状态回退)
  - [ ] 场景 6: 明日计划只读

- [ ] **性能优化**
  - [ ] Provider 刷新策略优化(使用 family 精确刷新)
  - [ ] 状态切换动画流畅度
  - [ ] 打卡对话框弹出速度

- [ ] **UI 细节打磨**
  - [ ] 状态切换过渡动画
  - [ ] 按钮点击触觉反馈
  - [ ] 成功/失败反馈提示

##### Phase 5: 文档更新 (1 小时)

- [ ] 更新 `docs/FAQ.md`
  - [ ] Q1: 补充状态流转图
  - [ ] 新增 Q: 如何补打卡?
- [ ] 更新 `docs/habit/DAILY_PLAN_USER_GUIDE.md`
  - [ ] 交互流程更新
  - [ ] 状态说明
- [ ] 更新 `PLAN.md`(本文件)

**负责**: @flutter_architect
**总预计时间**: 11 小时

**验收标准**:
- [ ] ✅ 状态流转正确(4 个场景测试通过)
- [ ] ✅ 数据同步准确(习惯列表 ↔ 次日计划)
- [ ] ✅ 防重复打卡生效
- [ ] ✅ 明日计划只读
- [ ] ✅ UI 状态清晰,交互流畅
- [ ] ✅ 数据库迁移成功,旧数据兼容

---

### Week 6: 通知和提醒功能（可选,未来 Phase 3+）

> 注: 次日计划核心交互优化完成后,通知功能作为增强体验的可选功能

#### Task 2.23: 集成 flutter_local_notifications

- [ ] 添加 `flutter_local_notifications` 依赖
- [ ] 配置 iOS 通知权限（Info.plist）
- [ ] 配置 Android 通知渠道
- [ ] 初始化通知服务
- [ ] 测试本地通知发送
- **负责**: @flutter_architect
- **预计时间**: 2 小时

#### Task 2.24: 实现计划提醒调度

- [ ] 创建通知调度服务
- [ ] 实现计划创建时自动注册通知
- [ ] 实现计划更新时重新调度通知
- [ ] 实现计划完成/删除时取消通知
- [ ] 处理时区和时间计算逻辑
- **负责**: @flutter_architect
- **预计时间**: 3 小时

#### Task 2.25: 提醒设置页面

- [ ] 实现全局提醒开关
- [ ] 实现免打扰时段设置（如 22:00-8:00）
- [ ] 实现提前提醒时间设置（准时/5分钟/10分钟/15分钟）
- [ ] 实现单个计划禁用提醒
- [ ] 保存设置到本地存储
- **负责**: @flutter_architect
- **预计时间**: 2 小时

#### Task 2.26: 通知权限处理

- [ ] 实现通知权限请求流程
- [ ] 处理权限被拒绝的场景
- [ ] 添加引导用户开启权限的提示
- [ ] 实现通知点击后跳转到计划详情页
- **负责**: @flutter_architect
- **预计时间**: 1 小时

### Phase 2 验收标准 ✓

**功能完整性**:

- [ ] 可以创建正向习惯和习惯替代
- [ ] 每日打卡流畅无误
- [ ] 连续天数和完成率计算准确
- [ ] 次日计划生成和管理正常
- [ ] Frontmatter 习惯感悟可编辑

**用户体验**:

- [ ] iOS 风格 UI 美观流畅
- [ ] 打卡操作 < 5 秒完成
- [ ] 动画过渡自然
- [ ] 空状态/错误状态友好

**技术指标**:

- [ ] 数据库操作无阻塞（后台线程）
- [ ] 页面切换流畅 60fps
- [ ] 测试覆盖率 > 60%
- [ ] 0 严重 Bug

**扩展性**:

- [ ] Repository 接口清晰，易于后续接入云端同步
- [ ] 数据模型与 UI 解耦
- [ ] 为 Phase 5 云端同步预留接口

---

## Phase 3: 灵感记录与反思 (2-3 周)

**目标**: 记录运动、工作、生活各领域的感悟

### 待规划 ⏳

- [ ] 多类型反思（运动/工作/生活）
- [ ] 富文本编辑器
- [ ] 图片/视频附件
- [ ] 标签系统
- [ ] 时间线视图
- [ ] 与目标关联

---

## Phase 4: 知识库与搜索 (2-3 周)

**目标**: 构建个人问题解决方案库

### 待规划 ⏳

- [ ] 知识条目 CRUD
- [ ] Markdown 支持
- [ ] 全文搜索（PostgreSQL tsvector）
- [ ] 分类和标签
- [ ] 收藏系统
- [ ] 导出功能（PDF/Markdown）

---

## Phase 5: 高级功能 (按需开发)

### 云端同步与数据管理

#### 已规划: Phase 2 本地数据导入导出 ✅
- ✅ Task 2.17: 本地数据导入导出功能（JSON/CSV/Markdown）
- 适用场景：设备迁移、数据备份、数据分析

#### 待规划: 云端同步功能 ⏳
- [ ] 用户认证系统（JWT + OAuth）
- [ ] 习惯数据云端同步（Go 后端 + PostgreSQL）
- [ ] 多设备实时同步
- [ ] 冲突解决策略（客户端优先/服务端优先/手动合并）
- [ ] 增量同步优化（仅同步变更数据）
- [ ] 离线队列管理（网络恢复后自动同步）

### 数据分析与可视化

- [ ] 数据分析仪表盘
  - 习惯完成趋势图（折线图、柱状图）
  - 习惯分类统计（饼图）
  - 核心习惯影响力分析
  - 周报/月报自动生成
- [ ] 目标/习惯关联分析
  - 习惯与目标完成度相关性分析
  - 习惯链（Habit Chain）可视化
  - 最佳执行时段分析

### 多用户与权限

- [ ] 多用户支持
- [ ] 用户认证系统
- [ ] 数据隔离与权限控制
- [ ] 家庭/团队共享功能（可选）

### 其他高级功能

- [ ] 深色模式完善
- [ ] iPad 适配优化
- [ ] Apple Watch 集成（快速打卡）
- [ ] Siri Shortcuts 支持
- [ ] Widget 桌面小组件
- [ ] 数据自动备份到 iCloud/Google Drive

---

## 风险与缓解措施

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| ltree 学习曲线 | 中 | 提前研究文档，准备示例查询 |
| 离线同步冲突复杂 | 高 | 使用简单的 Last Write Wins 策略 |
| Flutter 性能问题 | 中 | 持续 Profile，使用 const 和缓存 |
| Go 并发 bug | 中 | 使用 race detector，充分测试 |

---

## 每日站会检查项

- [ ] 昨天完成了什么？
- [ ] 今天计划做什么？
- [ ] 遇到什么阻碍？
- [ ] 需要其他 Agent 协助吗？

---

## 里程碑

- **M1 (Week 2)**: 数据模型和存储层完成
- **M2 (Week 4)**: 基础 UI 和 API 完成
- **M3 (Week 6)**: Phase 1 MVP 完成，可演示

---

## 本次更新总结 (2025-10-05)

### Phase 2 Week 1-4 已完成 ✅

**Week 1-2 完成的功能**:

- ✅ 习惯 CRUD（创建、编辑、删除）
- ✅ 习惯打卡功能（质量评分 1-5 星、笔记）
- ✅ 统计计算（连续天数、完成率）
- ✅ 搜索和筛选
- ✅ iOS 风格 UI（Cupertino 组件）
- ✅ 核心习惯功能支持（💎 核心习惯标记和筛选）

**Week 3-4 完成的功能**:

- ✅ 习惯详情页面（统计卡片、执行记录列表）
- ✅ 日历热力图（GitHub 风格，显示打卡质量）
- ✅ 次日计划功能（计划生成、完成跟踪）
- ✅ Frontmatter 习惯感悟（Markdown 编辑、标签系统、时间线）
- ✅ UI/UX 优化（页面切换动画、打卡成功反馈、成就通知）

**修复的问题**:

- 🐛 Hero 标签冲突（导航栏动画）
- 🐛 数据库 CHECK 约束命名问题
- 🐛 布局约束问题（Column/Row）
- 🐛 次日计划页面一直加载的问题
- 🐛 各类 UI bug 修复

**UI/UX 优化**:

- 🎨 点击卡片 → 进入详情页
- 🎨 左滑 → 删除确认（Dismissible）
- 🎨 独立打卡按钮（阻止事件冒泡）
- 🎨 空状态优化（精美插图）
- 🎨 加载状态优化
- 🎨 错误状态友好提示

**新增功能规划**:

- 📋 Task 2.17: 数据导入导出功能（JSON/CSV/Markdown 格式）

**新增文件数**: ~60+ 个
**代码行数**: ~4000+ 行

---

**最后更新**: 2025-10-05
**当前冲刺**: Phase 2, Week 4（路由配置已完成）
**Phase 2 完成度**: ~98%（核心功能全部完成，仅待测试与文档）

## 📚 用户文档

次日计划功能的详细使用说明已整理到专门的用户指南：

- **用户指南**: [`docs/habit/DAILY_PLAN_USER_GUIDE.md`](docs/habit/DAILY_PLAN_USER_GUIDE.md)
  - 完整的功能介绍和操作流程
  - UI 交互设计和最佳实践
  - 常见问题解答

- **需求文档**: [`docs/requirements.md`](docs/requirements.md) - 3.2.4 节
  - 次日计划功能详细需求描述
  - 计划定时提醒功能规划（Phase 3+）
