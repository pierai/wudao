# 悟道项目设置指南

## 已完成的配置

✅ 项目目录结构（feature-first 架构）
✅ pubspec.yaml 核心依赖配置
✅ main.dart 和 app.dart 基础配置
✅ Riverpod ProviderScope 配置
✅ 核心常量文件（AppColors, AppSizes, AppStrings）
✅ Cupertino 主题配置
✅ build.yaml 代码生成配置

## 需要手动完成的步骤

### 1. 确保 Flutter 环境可用

项目使用 FVM 管理 Flutter 版本（当前指定版本：3.35.5）

```bash
# 检查 FVM 和 Flutter 是否可用
fvm flutter --version

# 如果未安装 FVM，请先安装
# brew install fvm
# 或参考 https://fvm.app/docs/getting_started/installation
```

### 2. 安装依赖

```bash
cd /Users/pierai/Development/projects/flutter/wudao
fvm flutter pub get
```

### 3. 运行代码生成

```bash
# 生成 Riverpod、Freezed、JSON 序列化等代码
dart run build_runner build --delete-conflicting-outputs

# 或者使用 watch 模式（开发时推荐）
dart run build_runner watch --delete-conflicting-outputs
```

### 4. 验证项目运行

```bash
# 检查设备
fvm flutter devices

# 运行项目（iOS 模拟器）
fvm flutter run -d ios

# 或运行在 macOS
fvm flutter run -d macos
```

## 项目结构说明

```
lib/
├── main.dart                   # 应用入口，配置 ProviderScope
├── app.dart                    # WuDaoApp，配置 CupertinoApp
├── core/                       # 核心模块
│   ├── constants/             # 常量
│   │   ├── app_colors.dart   # 颜色常量
│   │   ├── app_sizes.dart    # 尺寸常量
│   │   └── app_strings.dart  # 字符串常量
│   ├── theme/                 # 主题
│   │   └── cupertino_theme.dart
│   ├── utils/                 # 工具类（待创建）
│   ├── database/              # Drift 数据库（待创建）
│   └── network/               # 网络层（待创建）
├── features/                   # 功能模块
│   ├── goals/                 # 目标管理（当前阶段）
│   ├── habits/                # 习惯追踪（未来）
│   ├── reflections/           # 灵感记录（未来）
│   └── knowledge/             # 知识库（未来）
├── shared/                     # 共享组件
│   ├── widgets/               # 共享 Widget
│   └── providers/             # 共享 Provider
└── routing/                    # 路由配置（待创建）
```

## 下一步开发任务

根据 PLAN.md，接下来的任务是：

### Week 1: 基础架构搭建（剩余任务）

- [ ] Task 1.2: 创建 iOS 风格底部导航
  - GlassNavigationBar 组件
  - CupertinoTabScaffold 配置
  - 4 个 Tab 页面

### Week 2: 目标数据模型与存储

- [ ] Task 2.1: 定义 Goal 数据模型（Freezed）
- [ ] Task 2.2: Drift 本地数据库设置
- [ ] Task 2.3: PostgreSQL 目标表实现
- [ ] Task 2.4: Go Repository 层

## 常用命令

```bash
# 检查过期依赖
fvm flutter pub outdated

# 更新依赖
fvm flutter pub upgrade

# 清理项目
fvm flutter clean

# 分析代码
fvm flutter analyze

# 格式化代码
fvm dart format .

# 运行测试
fvm flutter test
```

## 注意事项

1. **FVM 版本管理**：项目使用 FVM 管理 Flutter 版本（3.35.5），所有命令需添加 `fvm` 前缀
2. **iOS 开发**：确保 Xcode 已安装（macOS）
3. **代码生成**：修改 `@freezed` 或 `@riverpod` 注解后需要重新运行 build_runner
4. **主题**：项目采用 iOS 优先设计，使用 Cupertino 组件
5. **状态管理**：使用 Riverpod 2.6，推荐使用 `ConsumerWidget` 和 `AsyncNotifierProvider`

## 问题排查

如遇到问题，请参考 CLAUDE.md 中的"问题排查"章节。

---

**创建时间**: 2025-10-02
**Flutter 版本**: 3.35.5 (通过 FVM 管理)
