# 其他 Agent 配置文件

## 📁 文件放置位置

wudao/.claude/agents/
├── flutter_architect.md        # 已创建
├── go_backend.md              # 下面内容
├── database_designer.md       # 下面内容
└── integration_specialist.md  # 下面内容

wudao/.claude/
└── shortcuts.md               # 快捷指令

## 📦 最终文件结构总结

将以上内容保存为以下文件：

wudao/
├── .claude/
│   ├── agents/
│   │   ├── flutter_architect.md
│   │   ├── go_backend.md
│   │   ├── database_designer.md
│   │   └── integration_specialist.md
│   └── shortcuts.md
├── CLAUDE.md
├── PLAN.md
├── technical_architecture.md          # 之前生成的技术文档
└── docs/
    └── requirements.md

wudao-backend/
├── .claude/
│   └── backend_context.md            # 可选：后端专用上下文
└── README.md

## 🎉 现在您可以开始了

### 创建文件步骤

1. **在 `wudao` 项目根目录创建**:
   - `.claude/agents/` 文件夹
   - 复制上面 4 个 Agent 配置
   - 创建 `shortcuts.md`
   - 创建 `CLAUDE.md`, `PLAN.md`, `requirements.md`

2. **在 Claude Code 中打开项目**

3. **开始第一个对话**:

@flutter_architect

我已完成所有配置。请阅读 @CLAUDE.md 和 @PLAN.md。

第一个任务：配置 Flutter 项目依赖并创建基础架构。

请使用 planning mode 分解任务，然后逐步实现。

# 如何在 Claude Code 中使用 Agent

---

## 🎯 如何在 Claude Code 中激活 Agent

### 方法 A: 通过 @ 提及

@flutter_architect 请帮我创建目标列表页面
@go_backend 设计 /api/v1/goals 的完整 CRUD 端点
@database_designer 设计目标表的数据库模式
@integration_specialist 实现 Flutter 与后端的目标数据同步

### 方法 B: 在对话开头声明

作为 Flutter Mobile Architect，请帮我...

### 方法 C: 在 Custom Instructions 中设置（推荐）

1. 创建项目根目录的 `.claude/` 文件夹
2. 将上述 4 个 agent 配置文件放入
3. 在对话时使用 `@.claude/agents/flutter_architect.md` 引用

---

## 🚦 使用建议

### 何时使用哪个 Agent

| 任务类型 | 使用 Agent | 示例 |
|---------|-----------|------|
| 创建 UI 页面 | Flutter Architect | "创建目标详情页面" |
| 状态管理 | Flutter Architect | "用 Riverpod 管理目标列表状态" |
| API 开发 | Go Backend | "实现目标 CRUD API" |
| 数据库设计 | Database Designer | "设计目标表结构" |
| 前后端联调 | Integration Specialist | "实现目标的离线同步" |
| 全栈功能 | 多个 Agent 协作 | 先 Database → Backend → Flutter → Integration |

---

## 📦 额外推荐：创建 Agent 快捷指令

在 `.claude/shortcuts.md` 中定义：

```markdown
# Claude Code 快捷指令

## Flutter 相关
- `/new-screen <name>`: 创建新页面（使用 Flutter Architect）
- `/new-model <name>`: 创建 Freezed 数据模型
- `/add-provider <type>`: 添加 Riverpod Provider

## Go 相关
- `/new-endpoint <resource>`: 创建完整 CRUD 端点（使用 Go Backend）
- `/new-service <name>`: 创建服务层代码

## 数据库相关
- `/new-table <name>`: 设计新表结构（使用 Database Designer）
- `/migration <description>`: 生成数据库迁移脚本

## 集成相关
- `/connect <feature>`: 实现前后端集成（使用 Integration Specialist）

✅ 配置完成后的第一步
创建完这些 Agent 配置后，在 Claude Code 中测试：
@flutter_architect 

我已经完成了 agent 配置。现在开始第一个任务：

为"悟道"应用创建基础的 Flutter 项目结构，包括：
1. 配置 pubspec.yaml 依赖
2. 创建 feature-first 目录结构
3. 设置 Riverpod 的基础 ProviderScope
4. 创建 iOS 风格的底部导航栏（带玻璃效果）

请使用 planning mode 分解任务，并逐步实现。
