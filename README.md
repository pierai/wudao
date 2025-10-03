# wudao

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Claude 使用

## MCP配置

claude --dangerously-skip-permissions
claude mcp add-json github '{"command":"npx","args":["-y","@modelcontex
      tprotocol/server-github"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":""}}'

claude mcp add-json dart '{"command":"fvm
      dart","args":["mcp-server","--force-roots-fallback"]}'
claude mcp get github
claude mcp list
其他命令：claude mcp remove dart
claude mcp remove dart -s user && claude mcp remove
      dart -s project 2>/dev/null || true

### dart MCP配置

│ MCP Config locations (by scope):                                                                     │
│  • User config (available in all your projects):                                                     │
│    • /Users/pierai/.claude.json                                                                      │
│  • Project config (shared via .mcp.json):                                                            │
│    • /Users/pierai/Development/projects/flutter/wudao/.mcp.json (file does not exist)                │
│  • Local config (private to you in this project):                                                    │
│    • /Users/pierai/.claude.json [project: /Users/pierai/Development/projects/flutter/wudao]

Dart MCP server 已添加，但连接失败。这通常是因为还没有安装 Dart MCP server 包。需要先激活：fvm dart pub global activate mcp_server
查看全局包：fvm dart pub global list
"dart": {
      "command": "fvm dart",
      "args": [
        "mcp-server",
        "--flutter-sdk",
        "/Users/pierai/fvm/versions/3.35.5",
        "--force-roots-fallback"
      ]
    }

## Agent配置

### 项目级配置

/Users/pierai/Development/projects/flutter/wudao/
├── .claude/                          # 项目级配置
│   ├── agents/
│   │   ├── flutter_architect.md      # 项目特定 agent
│   │   ├── go_backend.md
│   │   └── integration_specialist.md
│   └── prompts/                      # 可选：项目提示词
└── ...其他项目文件

### 全局配置（不在项目中）

~/Library/Application Support/Claude/
└── claude_desktop_config.json        # MCP 服务器配置

# 常用指令

```bash
fvm flutter clean && fvm flutter pub get &&
fvm dart run build_runner build --delete-conflicting-outputs

fvm flutter pub upgrade --major-versions
fvm dart analyze xx.dart

# 检查环境
1. 重启 Dart Analysis Server：
    - 按 Cmd+Shift+P
    - 输入 "Dart: Restart Analysis Server"
    - 执行
2. 检查 Flutter SDK 是否被识别：
    - 按 Cmd+Shift+P
    - 输入 "Flutter: Run Flutter Doctor"
    - 查看输出
```

# 运行到 MacOS

## 首次构建步骤

```bash
# 1. 获取 Flutter 依赖
fvm flutter pub get

# 2. 直接运行（推荐）： -d 指定设备ID
fvm flutter run -d macos

# 或者先构建再运行
fvm flutter build macos --debug
# 然后在 Xcode 中打开 macos/Runner.xcworkspace 运行
```

**注意**：

- `fvm flutter run -d macos` 会自动执行构建并生成必要文件（如 xcfilelist），推荐使用
- `fvm flutter build macos --debug` 仅在需要手动构建或修复配置问题时使用
- CocoaPods 的配置警告可以忽略（已在 xcconfig 中手动配置）

## 常见问题

### 问题 1: pod install 下载超时

```bash
# 配置 CocoaPods 源
pod repo remove trunk
pod repo add tuna https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git
# 清空 Pods 缓存
rm -f Podfile.lock
pod cache clean --all
rm -rf Pods
pod install --repo-update
```

### 问题 2: xcfilelist 文件缺失

```bash
# 清理并重建
fvm flutter clean
fvm flutter pub get
fvm flutter run -d macos  # 会自动生成
```

### 问题 3: sandbox 不同步错误

```bash
# 完整清理重建
cd macos
rm -rf Pods Podfile.lock
cd ..
fvm flutter clean
fvm flutter pub get
fvm flutter run -d macos
```

### 问题 4: VS Code 调试时 VM Service 无法启动

**错误信息**：
```
SocketException: Failed to create server socket (OS Error: Operation not permitted, errno = 1)
```

**原因**：macOS App Sandbox 缺少网络权限，导致 VM Service 无法监听端口进行调试。

**解决方案**：在 entitlements 文件中添加网络权限：

`macos/Runner/DebugProfile.entitlements`：
```xml
<key>com.apple.security.network.server</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

`macos/Runner/Release.entitlements`：
```xml
<key>com.apple.security.network.client</key>
<true/>
```

修改后执行：
```bash
flutter clean
# 然后在 VS Code 中重新运行调试配置
```

**注意**：
- 命令行 `flutter run` 不受影响，因为使用了不同的权限配置
- VS Code 中的 `.vscode/settings.json` 需要配置正确的 Flutter SDK 路径：
  ```json
  // ✅ 推荐：使用 FVM 符号链接（跨设备兼容）
  "dart.flutterSdkPath": ".fvm/flutter_sdk"

  // ❌ 避免：VS Code Dart 扩展可能无法识别
  // "dart.flutterSdkPath": ".fvm/versions/3.35.5"

  // ⚠️ 备选：绝对路径（不推荐，不跨设备）
  // "dart.flutterSdkPath": "/Users/pierai/Development/projects/flutter/wudao/.fvm/versions/3.35.5"
  ```

## 预缓存资源

```bash
# 下载 iOS/macOS 平台编译工具
fvm flutter precache --ios

```
