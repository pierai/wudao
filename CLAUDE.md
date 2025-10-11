# 悟道 (WuDao) - 人生成长与效率管理应用

## 项目概述

**悟道**是一款基于《高效能人士的七个习惯》和《习惯的力量》设计的个人成长应用，帮助用户：

- 建立和追踪人生目标（以终为始）
- 培养和监控核心习惯和习惯替代
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

**重要提示**（Riverpod 3.0+）:

从 Riverpod 3.0 开始，`StateProvider`、`StateNotifierProvider` 和 `ChangeNotifierProvider` 已被视为 legacy API。虽然这些代码可能仍然可以工作，但从长远来看，为了更好的代码质量、可维护性以及利用 Riverpod 的最新特性，**强烈建议**：

- ✅ **新项目**：直接使用 `NotifierProvider` 和 `AsyncNotifierProvider`
- ⚠️ **现有项目**：逐步将 `StateProvider` 迁移到 `NotifierProvider`
- 📚 **推荐使用**：`Provider`、`FutureProvider`、`StreamProvider`、`Notifier`、`AsyncNotifier`、`StreamNotifier`

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

### ADR-005: 习惯类型三分类系统

**背景**:
- 初版使用 `type` (positive/replacement) + `isKeystone` 布尔值标识核心习惯
- UI臃肿：5个Tab（生活、学习、健康、工作、运动）+ 核心/普通筛选
- 关联功能操作复杂，正向习惯和核心习惯分开展示不便于建立关联

**决策**:
采用三种互斥的习惯类型系统：
- **💎 核心习惯 (core)**: 能够引发连锁反应，带动其他习惯形成的关键习惯
- **🔄 习惯替代 (replacement)**: 通过替换惯常行为来改变不良习惯，保持相同暗示和奖赏
- **✅ 正向习惯 (positive)**: 要建立的新习惯，包含完整的暗示-惯常行为-奖赏回路

**实现**:
1. 移除 `isKeystone` 字段，使用 `type = 'CORE'` 直接标识
2. Tab改为按类型分类（核心/替代/正向），而非按分类（生活/工作/运动）
3. 核心习惯Tab实现分区布局：核心习惯区 + 未关联习惯区
4. 实现拖拽关联功能：长按未关联习惯拖到核心习惯上建立关联
5. 分类简化为3个枚举：life/work/sport

**优势**:
- ✅ UI简洁：3个Tab替代原来的5个分类Tab
- ✅ 类型语义清晰：一个习惯只有一种类型，避免概念混淆
- ✅ 操作直观：拖拽关联符合iOS用户习惯，类似文件管理
- ✅ 数据库优化：减少一个字段，查询更简单
- ✅ 向后兼容：数据库迁移自动转换旧数据

**数据库迁移** (Schema v6):
```sql
-- 移除 isKeystone 列，将 isKeystone=true 的习惯转为 type='CORE'
UPDATE habits SET type = 'CORE' WHERE isKeystone = 1 AND type != 'REPLACEMENT';
ALTER TABLE habits DROP COLUMN isKeystone;
```

### ADR-006: 习惯关联采用拖拽交互

**背景**:
用户需要将正向习惯和习惯替代关联到核心习惯，但两者在不同Tab中展示，建立关联不便。

**决策**:
在核心习惯Tab中实现拖拽关联功能（方案A）：
- 核心习惯区：展示所有核心习惯及其关联的习惯（可展开）
- 未关联习惯区：显示未被关联的正向/替代习惯
- 拖拽交互：长按未关联习惯，拖到核心习惯上建立关联

**替代方案**:
- ❌ 方案B：新增"全部习惯"Tab专门管理关联（增加复杂度）
- ❌ 方案C：进入"编辑模式"后从抽屉拖拽（步骤繁琐）
- ❌ 方案D：跨Tab拖拽（实现复杂，用户难以发现）

**实现细节**:
```dart
// 核心习惯卡片使用DragTarget接收拖拽
DragTarget<Habit>(
  onWillAcceptWithDetails: (details) => details.data.type != HabitType.core,
  onAcceptWithDetails: (details) => _createAssociation(...),
  builder: (context, candidateData, rejectedData) {
    final isHovering = candidateData.isNotEmpty;
    return Container(
      decoration: isHovering ? Border.all(color: activeBlue, width: 2) : null,
      child: HabitCard(...),
    );
  },
)

// 未关联习惯使用LongPressDraggable支持拖拽
LongPressDraggable<Habit>(
  data: habit,
  feedback: Material(...), // 拖拽时的视觉反馈
  childWhenDragging: Opacity(opacity: 0.3, ...), // 原位置幽灵效果
  child: HabitCard(...),
)
```

**用户体验**:
- ✅ 拖拽中：卡片80%不透明度 + 阴影 + 原位置30%幽灵效果
- ✅ 悬停时：核心习惯卡片蓝色边框高亮
- ✅ 成功后：Cupertino风格提示，习惯从未关联区消失
- ✅ 已关联标记：正向/替代Tab显示蓝色"🔗已关联"徽章

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

### Phase 1: 人生目标管理 MVP（待完成）

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

### Phase 2: 习惯追踪模块（已完成核心功能）

**已完成功能** ✅:

1. **习惯类型系统**
   - 三种互斥类型：核心习惯、习惯替代、正向习惯
   - 数据库Schema v6，支持从旧版本自动迁移
   - 3个分类：生活(life)、工作(work)、运动(sport)

2. **习惯管理**
   - 习惯CRUD操作（创建/编辑/删除/归档）
   - 习惯搜索和筛选
   - 习惯循环：暗示(Cue) → 惯常行为(Routine) → 奖赏(Reward)
   - 习惯替代需要填写原惯常行为(Old Routine)

3. **习惯关联系统**
   - 拖拽关联：长按未关联习惯拖到核心习惯上
   - 关联查询：查看核心习惯的所有伴随习惯
   - 未关联习惯列表：实时监听未被关联的习惯
   - 已关联标记：在正向/替代Tab显示蓝色徽章

4. **打卡记录**
   - 每日打卡（支持质量评分1-5星）
   - 打卡历史查询和月度日历展示
   - 连续天数统计（当前连续、最佳连续）
   - 完成率计算和可视化

5. **明日计划**
   - 创建次日计划并设置计划时间
   - 计划状态管理：pending → cueCompleted → checkedIn
   - 支持跳过计划(skipped)
   - 计划完成率统计

6. **Frontmatter灵感记录**
   - Markdown格式记录灵感和感悟
   - 支持标签分类和搜索
   - 与习惯关联（可引用习惯）

**UI实现重点**:

- **核心习惯Tab**:
  - 📂 核心习惯区（可展开显示关联习惯）
  - 未关联习惯区（支持长按拖拽）
  - 拖拽悬停时蓝色边框高亮

- **正向习惯/习惯替代Tab**:
  - 显示对应类型的所有习惯
  - 已关联习惯显示"🔗已关联"徽章

- **习惯表单**:
  - 3选项类型选择器（核心/替代/正向）
  - 紧凑的分类按钮布局
  - 智能字段显示（习惯替代时显示原惯常行为）

**数据库设计**:

```
habits (习惯表)
├─ id, name, cue, routine, old_routine, reward
├─ type: POSITIVE | CORE | REPLACEMENT
├─ category: life | work | sport
└─ is_active, created_at, updated_at, deleted_at

habit_associations (关联表)
├─ keystone_habit_id (核心习惯ID)
├─ associated_habit_id (关联习惯ID)
└─ created_at

habit_records (打卡记录表)
habit_plans (明日计划表)
frontmatters (灵感记录表)
```

**待完成功能** ⏳:

- 习惯提醒通知
- 习惯统计报表和趋势图
- 习惯模板库
- 批量操作（批量关联、批量归档）

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

### 数据模型规范（Freezed）

本项目使用 `freezed` 包管理数据模型。所有使用 `@freezed` 注解的类**必须**同时声明为 `sealed class`。

**✅ 正确示例**:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';

@freezed
sealed class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
    required String name,
    String? description,
  }) = _ExampleModel;

  const ExampleModel._();

  // 可以添加自定义方法
  bool get isValid => name.isNotEmpty;
}
```

**❌ 错误示例**:

```dart
// 缺少 sealed 关键字
@freezed
class ExampleModel with _$ExampleModel {
  // ...
}
```

**关键点**:

- 使用 `sealed class` 确保编译时类型安全
- 添加 `const ExampleModel._();` 以支持自定义方法和 getter
- 使用 `part` 指令关联生成文件
- 运行 `dart run build_runner build --delete-conflicting-outputs` 生成代码

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

## FVM 配置

### VS Code Flutter SDK 路径设置

在 `.vscode/settings.json` 中配置：

```json
{
  // ✅ 推荐：使用 FVM 符号链接
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

**工作原理**：

- FVM 在项目根目录创建 `.fvm/flutter_sdk` 符号链接
- 该链接指向全局 FVM 缓存中的实际 SDK：`/Users/用户名/fvm/versions/3.35.5`
- 切换版本时（`fvm use`），链接自动更新

**为什么推荐这种方式**：

| 配置方式 | 优点 | 缺点 |
|---------|------|------|
| ✅ `.fvm/flutter_sdk` | 跨设备兼容<br>版本切换自动生效<br>路径简洁 | 需要 FVM |
| ❌ `.fvm/versions/3.35.5` | 无 | VS Code Dart 扩展可能无法识别 |
| ⚠️ 绝对路径 | 明确清晰 | 不跨设备<br>需手动更新<br>路径冗长 |

### 验证配置

修改后在 VS Code 中：

1. 重启 Dart Analysis Server：`Cmd+Shift+P` → "Dart: Restart Analysis Server"
2. 验证 SDK：`Cmd+Shift+P` → "Flutter: Run Flutter Doctor"

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

**Q: VS Code 调试时 VM Service 无法启动（SocketException: Operation not permitted）？**
A: 需要同时解决两个问题：

1. **网络权限问题**：macOS App Sandbox 缺少网络权限
   - `macos/Runner/DebugProfile.entitlements`：添加 `com.apple.security.network.server` 和 `com.apple.security.network.client`
   - `macos/Runner/Release.entitlements`：添加 `com.apple.security.network.client`

2. **Flutter SDK 路径配置**：`.vscode/settings.json` 中正确设置：

   ```json
   // ✅ 推荐：FVM 符号链接
   "dart.flutterSdkPath": ".fvm/flutter_sdk"

   // ❌ 避免：相对路径可能无法识别
   // "dart.flutterSdkPath": ".fvm/versions/3.35.5"
   ```

3. 修改后执行 `flutter clean` 并重启 VS Code Dart Analysis Server

**Q: macOS 平台通知初始化错误？**
A: `flutter_local_notifications` 需要为 macOS 单独配置 `DarwinInitializationSettings`：

```dart
const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(...);
const InitializationSettings(...
  iOS: initializationSettingsDarwin,
  macOS: initializationSettingsDarwin,  // 必须添加
);
```

**Q: macOS 文件选择器无响应？**
A: 需要在 entitlements 中添加文件访问权限：

- `macos/Runner/DebugProfile.entitlements` 和 `macos/Runner/Release.entitlements` 中添加：

  ```xml
  <key>com.apple.security.files.user-selected.read-write</key>
  <true/>
  ```

- 修改后执行 `flutter clean`

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

- [中文技术架构](technical_architecture_zh.md)

---

**最后更新**: 2025-10-11
**版本**: v0.3.0-alpha

## 更新日志

### v0.3.0-alpha (2025-10-11)

**重大更新**:
- ✨ 实现习惯拖拽关联功能（方案A）
- 🔄 重构习惯类型系统（type三分类替代type+isKeystone）
- 🎨 优化UI布局（3个Tab替代5个分类Tab）
- 📦 数据库迁移到Schema v6
- 📚 更新种子数据和文档

**功能增强**:
- 核心习惯Tab分区布局（核心习惯区 + 未关联习惯区）
- 长按拖拽交互，iOS原生体验
- 已关联习惯显示蓝色徽章
- 分类选择器UI优化（紧凑按钮布局）

**技术改进**:
- 新增 `watchUnassociatedHabits` DAO查询
- 新增 `unassociatedHabitsProvider` 和 `isHabitAssociatedProvider`
- DragTarget + LongPressDraggable 实现拖拽
- 完善习惯关联的数据层和UI层

**文档更新**:
- 新增 ADR-005: 习惯类型三分类系统
- 新增 ADR-006: 习惯关联采用拖拽交互
- 更新开发阶段说明和数据库设计文档
- 同步优化种子数据文件和说明文档

### v0.2.0-alpha (2025-10-07)

**初版功能**:
- ✅ 习惯CRUD基础功能
- ✅ 打卡记录和统计
- ✅ 明日计划系统
- ✅ Frontmatter灵感记录
- ✅ 习惯关联基础数据结构
