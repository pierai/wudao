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
