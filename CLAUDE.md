# 悟道 (WuDao) - 人生成长与效率管理应用

## 项目概述

**悟道**是一款基于《高效能人士的七个习惯》和《习惯的力量》设计的个人成长应用，帮助用户：

- 建立和追踪人生目标（以终为始）
- 培养和监控核心习惯（触发机制）
- 记录运动、工作、生活的灵感与感悟
- 构建个人知识库和解决方案库

## 技术栈

### 前端

- **Flutter**: 3.35.5+
- **状态管理**: Riverpod 3.0
- **本地存储**: Drift 2.20.0 (SQLite)
- **网络请求**: Dio 5.4.0
- **数据模型**: Freezed 2.4.6 + json_serializable

### 后端

- **语言**: Go 1.23+
- **框架**: Gin 1.10.0
- **数据库**: PostgreSQL 16 (ltree + TimescaleDB)
- **认证**: API Key → JWT（渐进式）

### 部署

- **方式**: Docker Compose 自托管
- **目标平台**: iOS/macOS（优先）→ Android → Web

## 架构决策记录 (ADR)

### ADR-001: 采用 Riverpod 作为状态管理方案

**原因**:

- 编译时安全，避免运行时错误
- 无需 BuildContext，测试更简单
- 与 code generation 完美集成

### ADR-002: 使用 Drift 而非 Hive

**原因**:

- 类型安全的 SQL 查询
- 支持复杂关系和事务
- 跨平台兼容（包括 Web）

### ADR-003: iOS 优先的设计语言

**原因**:

- 目标用户主要使用 iOS 设备
- Cupertino 组件提供原生体验
- 玻璃效果符合现代 iOS 设计趋势

### ADR-004: 离线优先架构

**原因**:

- 提升用户体验（即时响应）
- 应对网络不稳定
- 降低服务器负载

## 项目结构

```
lib/
├── main.dart
├── app.dart                    # MaterialApp/CupertinoApp 配置
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_sizes.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── cupertino_theme.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   ├── database/
│   │   ├── database.dart       # Drift database
│   │   ├── daos/
│   │   └── tables/
│   └── network/
│       ├── api_client.dart     # Dio 配置
│       ├── interceptors/
│       └── api_exception.dart
├── features/
│   ├── goals/                  # 目标管理（当前阶段）
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── habits/                 # 习惯追踪（未来）
│   ├── reflections/            # 灵感记录（未来）
│   └── knowledge/              # 知识库（未来）
├── shared/
│   ├── widgets/
│   │   ├── glass_container.dart
│   │   ├── glass_navigation_bar.dart
│   │   └── loading_indicator.dart
│   └── providers/
│       ├── connectivity_provider.dart
│       └── sync_provider.dart
└── routing/
    └── app_router.dart
```

## 当前开发阶段

### Phase 1: 人生目标管理 MVP（进行中）

**核心功能**:

1. ✅ 项目初始化
2. 🔄 层级目标树展示（5层：人生-领域-年度-季度-项目）
3. ⏳ 目标 CRUD 操作
4. ⏳ 进度追踪和可视化
5. ⏳ 目标状态管理（活跃/已完成/已归档）

**技术实现重点**:

- 使用 ltree 类型存储层级路径
- CupertinoListSection 展示目标层级
- AsyncNotifierProvider 管理目标状态
- 离线优先：本地 Drift 存储 + 云端同步

## 代码规范

### Dart/Flutter

```dart
// ✅ 好的实践
class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    
    return goalsAsync.when(
      data: (goals) => GoalsList(goals: goals),
      loading: () => const CupertinoActivityIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}

// ❌ 避免的实践
class GoalListScreen extends StatefulWidget {
  // 不使用 StatefulWidget，除非必要
}
```

### 命名规范

- 文件名: `goal_list_screen.dart`
- 类名: `GoalListScreen`
- Provider: `goalsProvider`
- 常量: `kDefaultPadding`

### Git Commit 规范

```
feat: 添加目标列表页面
fix: 修复目标删除时的同步问题
refactor: 重构 Repository 层
docs: 更新 README
test: 添加目标创建测试
```

## 依赖管理

### 核心依赖

```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  drift: ^2.20.0
  dio: ^5.4.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  liquid_glassmorphism: ^0.0.1

dev_dependencies:
  build_runner: ^2.4.7
  riverpod_generator: ^3.0.0
  drift_dev: ^2.20.0
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

### 更新依赖

```bash
# 检查过期依赖
flutter pub outdated

# 更新依赖
flutter pub upgrade

# 重新生成代码
dart run build_runner build --delete-conflicting-outputs
```

## 测试策略

### 测试金字塔

1. **单元测试** (70%): 模型、工具、业务逻辑
2. **Widget 测试** (20%): 关键 UI 组件
3. **集成测试** (10%): 端到端关键流程

### 运行测试

```bash
# 单元测试
flutter test

# 集成测试（需要模拟器/设备）
flutter test integration_test

# 生成覆盖率报告
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 性能优化检查清单

- [ ] 使用 `const` 构造函数
- [ ] `ListView.builder` 替代 `ListView`
- [ ] 图片使用缓存 (`CachedNetworkImage`)
- [ ] 避免在 `build` 方法中创建对象
- [ ] 使用 `Selector` 精确监听状态
- [ ] 大列表使用分页加载
- [ ] 使用 `RepaintBoundary` 隔离复杂 Widget

## 问题排查

### 常见问题

**Q: Hot reload 不生效？**
A: 检查是否修改了 main() 或 const 构造函数，需要 hot restart

**Q: Build runner 生成失败？**
A:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Q: Drift 查询报错？**
A: 检查是否执行了数据库迁移，确保表结构最新

## 相关文档

- 详细技术架构: `technical_architecture.md`
- 开发计划: `PLAN.md`
- API 文档: `wudao-backend/docs/swagger.yaml`
- 需求文档: `docs/requirements.md`

## 联系方式

- 项目负责人: [Your Name]
- 技术栈问题: 参考本文档
- Bug 报告: GitHub Issues (如果有仓库)

## 参考文档

- technical_architecture.md

---

**最后更新**: 2025-10-01
**版本**: v0.1.0-alpha
