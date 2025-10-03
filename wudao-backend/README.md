# 悟道后端 API

基于 Go + Gin + PostgreSQL 的个人成长应用后端服务。

## 技术栈

- **语言**: Go 1.23+
- **框架**: Gin 1.10.0
- **数据库**: PostgreSQL 16 (ltree + TimescaleDB)
- **认证**: API Key → JWT（渐进式）

## 项目结构

```
wudao-backend/
├── cmd/
│   └── api-server/          # 主程序入口
│       └── main.go
├── internal/                # 内部代码（不可外部导入）
│   ├── api/
│   │   └── handlers/        # HTTP 请求处理
│   ├── domain/              # 领域模型和接口
│   ├── service/             # 业务逻辑
│   └── repository/          # 数据访问层
│       └── postgres/
├── pkg/                     # 可复用库（可选）
├── migrations/              # 数据库迁移脚本
├── .env                     # 环境变量（不提交）
├── .env.example             # 环境变量模板
├── docker-compose.yml       # Docker 编排
└── README.md
```

## 快速开始

### 1. 环境准备

```bash
# 安装 Go 1.23+
brew install go

# 复制环境变量文件
cp .env.example .env

# 编辑 .env 配置数据库连接信息
```

### 2. 启动数据库（Docker）

```bash
docker-compose up -d postgres
```

### 3. 运行迁移

```bash
go run cmd/migrate/main.go up
```

### 4. 启动服务

```bash
# 开发模式（热重载）
air

# 或直接运行
go run cmd/api-server/main.go
```

服务将在 `http://localhost:8080` 启动。

### 5. 查看 API 文档

访问 `http://localhost:8080/swagger/index.html`

## 开发指南

### 安装依赖

```bash
go mod download
```

### 运行测试

```bash
# 运行所有测试
go test ./...

# 运行测试并生成覆盖率
go test -race -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### 生成 Swagger 文档

```bash
swag init -g cmd/api-server/main.go
```

### 代码格式化

```bash
go fmt ./...
```

### 代码检查

```bash
golangci-lint run
```

## API 端点

### 健康检查

- `GET /health` - 服务健康状态

### 目标管理（计划中）

- `GET /api/v1/goals` - 获取目标列表
- `GET /api/v1/goals/:id` - 获取目标详情
- `POST /api/v1/goals` - 创建目标
- `PUT /api/v1/goals/:id` - 更新目标
- `DELETE /api/v1/goals/:id` - 删除目标
- `GET /api/v1/goals/:id/children` - 获取子目标

## 部署

### Docker 部署

```bash
# 构建镜像
docker-compose build

# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f api
```

### 生产环境配置

1. 设置环境变量
2. 配置 TLS 证书
3. 设置 Caddy 反向代理
4. 配置数据库备份

## 许可

私有项目
