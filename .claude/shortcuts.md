# Claude Code 快捷指令

## 🎯 如何使用

在 Claude Code 对话中输入这些快捷指令，快速启动常见任务。

---

## 📱 Flutter 相关

### `/flutter-screen <name>`

创建新的 Cupertino 风格页面

**示例**:

```

/flutter-screen GoalDetail

```

**执行内容**:

1. 创建 `goal_detail_screen.dart`
2. 实现 CupertinoPageScaffold 结构
3. 添加导航栏和基础布局
4. 创建对应的测试文件

---

### `/flutter-model <name>`

创建 Freezed 数据模型

**示例**:

```

/flutter-model Goal

```

**执行内容**:

1. 创建 `goal.dart` 文件
2. 添加 Freezed 和 JSON 序列化注解
3. 生成代码命令提示

---

### `/flutter-provider <type> <name>`

添加 Riverpod Provider

**示例**:

```

/flutter-provider AsyncNotifier GoalsNotifier

```

**执行内容**:

1. 创建对应类型的 Provider
2. 实现基础结构
3. 添加使用示例

---

### `/flutter-repo <name>`

创建 Repository 接口和实现

**示例**:

```

/flutter-repo Goal

```

**执行内容**:

1. 创建抽象接口
2. 实现 API Repository
3. 实现 Local Repository
4. 配置依赖注入

---

## 🔧 Go 后端相关

### `/go-endpoint <resource>`

创建完整 CRUD 端点

**示例**:

```

/go-endpoint goal

```

**执行内容**:

1. Domain 模型
2. Repository 接口和实现
3. Service 层
4. Handler 层
5. Routes 配置
6. Swagger 注解

---

### `/go-migration <name>`

生成数据库迁移脚本

**示例**:

```

/go-migration add_goals_table

```

**执行内容**:

1. 创建 `XXX_<name>.up.sql`
2. 创建 `XXX_<name>.down.sql`
3. 添加迁移说明

---

### `/go-middleware <name>`

创建 Gin 中间件

**示例**:

```

/go-middleware RateLimit

```

**执行内容**:

1. 创建中间件函数
2. 添加配置选项
3. 使用示例

---

## 🗄️ 数据库相关

### `/db-table <name>`

设计新表结构

**示例**:

```

/db-table habits

```

**执行内容**:

1. CREATE TABLE 语句
2. 索引设计
3. 约束定义
4. 触发器（如需要）
5. 迁移脚本

---

### `/db-query <description>`

生成优化的 SQL 查询

**示例**:

```

/db-query 获取某目标的所有子目标

```

**执行内容**:

1. SQL 查询语句
2. 索引建议
3. 性能考虑

---

## 🔗 集成相关

### `/integrate <feature>`

实现前后端完整集成

**示例**:

```

/integrate goals

```

**执行内容**:

1. Flutter Repository 实现
2. API Client 配置
3. 离线同步逻辑
4. 错误处理
5. 集成测试

---

### `/test-integration <feature>`

生成集成测试

**示例**:

```

/test-integration goal-creation

```

**执行内容**:

1. Flutter integration test
2. Go API test
3. 测试场景覆盖

---

## 🛠️ 通用指令

### `/review-code`

代码审查检查清单

**执行内容**:

1. 检查命名规范
2. 检查错误处理
3. 检查性能问题
4. 检查安全隐患
5. 生成改进建议

---

### `/optimize <file>`

性能优化建议

**示例**:

```

/optimize lib/features/goals/presentation/screens/goal_list_screen.dart

```

**执行内容**:

1. 识别性能瓶颈
2. Widget 重建优化
3. 内存优化建议

---

### `/docs <feature>`

生成文档

**示例**:

```

/docs goals-api

```

**执行内容**:

1. API 文档（Swagger）
2. 使用指南
3. 示例代码

---

## 📋 项目管理

### `/status`

检查当前进度

**执行内容**:

1. 读取 @PLAN.md
2. 列出已完成任务
3. 列出进行中任务
4. 建议下一步

---

### `/next-task`

获取下一个任务

**执行内容**:

1. 从 @PLAN.md 读取
2. 推荐优先级最高的未完成任务
3. 提供任务详情

---

### `/update-plan`

更新开发计划

**执行内容**:

1. 标记已完成任务
2. 更新进度
3. 调整时间估算

---

## 🎓 学习和参考

### `/example <topic>`

查看代码示例

**示例**:

```

/example riverpod-async-notifier
/example ltree-query
/example dio-interceptor

```

---

### `/best-practice <topic>`

获取最佳实践

**示例**:

```

/best-practice flutter-state-management
/best-practice go-error-handling
/best-practice postgres-indexing

```

---

## 🚀 快速启动

### `/init-flutter`

初始化 Flutter 项目结构

**执行内容**:

1. 创建目录结构
2. 配置 pubspec.yaml
3. 设置 Riverpod
4. 创建基础组件

---

### `/init-backend`

初始化 Go 后端结构

**执行内容**:

1. 创建标准目录结构
2. 配置 go.mod
3. 设置 Gin 路由
4. 配置数据库连接

---

### `/init-docker`

初始化 Docker 配置

**执行内容**:

1. 创建 Dockerfile
2. 创建 docker-compose.yml
3. 配置环境变量

---

## 💡 使用技巧

1. **组合使用**: 可以在一个对话中使用多个快捷指令

   ```

   /flutter-model Goal
   /flutter-repo Goal
   /go-endpoint goal
   /integrate goals

   ```

2. **查看帮助**: 输入 `/help <command>` 查看详细说明

   ```

   /help flutter-screen

   ```

3. **自定义**: 您可以根据项目需要添加自定义快捷指令
