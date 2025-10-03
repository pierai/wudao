# 悟道 - 开发计划

## 总体路线图

```
Phase 1: 人生目标管理 MVP    ← 当前阶段
    ↓
Phase 2: 习惯追踪系统
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

## Phase 2: 习惯追踪系统 (3-4 周)

**目标**: 基于《习惯的力量》实现习惯追踪和触发机制管理

### 待规划 ⏳

- [ ] 习惯定义（名称、频率、触发机制）
- [ ] 每日打卡界面
- [ ] 连续打卡统计
- [ ] TimescaleDB 时间序列存储
- [ ] 习惯趋势可视化（图表）
- [ ] 提醒通知（本地通知）

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

### 待规划 ⏳

- [ ] 数据分析仪表盘
- [ ] 目标/习惯关联分析
- [ ] 数据导出/导入
- [ ] 多设备同步优化
- [ ] 用户认证系统（多用户支持）
- [ ] 备份与恢复
- [ ] 深色模式完善
- [ ] iPad 适配优化

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

**最后更新**: 2025-10-01  
**当前冲刺**: Phase 1, Week 1
