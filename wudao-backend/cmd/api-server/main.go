package main

import (
	"fmt"
	"log"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/pierai/wudao-backend/internal/api/handlers"
	"github.com/pierai/wudao-backend/internal/domain"
)

// @title 悟道 API
// @version 0.1.0
// @description 基于《高效能人士的七个习惯》的个人成长应用后端 API
// @contact.name API Support
// @contact.email support@wudao.com
// @license.name Private
// @host localhost:8080
// @BasePath /
func main() {
	// 加载配置
	config, err := domain.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// 设置 Gin 模式
	gin.SetMode(config.GinMode)

	// 创建 Gin 路由器
	router := gin.Default()

	// 配置 CORS 中间件
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{config.AllowedOrigin},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	// 注册路由
	registerRoutes(router)

	// 启动服务器
	addr := fmt.Sprintf(":%s", config.Port)
	log.Printf("Server starting on %s", addr)

	if config.TLSCertPath != "" && config.TLSKeyPath != "" {
		log.Printf("Starting HTTPS server")
		if err := router.RunTLS(addr, config.TLSCertPath, config.TLSKeyPath); err != nil {
			log.Fatalf("Failed to start HTTPS server: %v", err)
		}
	} else {
		log.Printf("Starting HTTP server (dev mode)")
		if err := router.Run(addr); err != nil {
			log.Fatalf("Failed to start HTTP server: %v", err)
		}
	}
}

// registerRoutes 注册所有路由
func registerRoutes(router *gin.Engine) {
	// 健康检查
	router.GET("/health", handlers.HealthCheck)

	// API v1 路由组
	v1 := router.Group("/api/v1")
	{
		// 目标管理路由（待实现）
		goals := v1.Group("/goals")
		{
			_ = goals // 占位，避免未使用变量错误
			// goals.GET("", handlers.ListGoals)
			// goals.GET("/:id", handlers.GetGoal)
			// goals.POST("", handlers.CreateGoal)
			// goals.PUT("/:id", handlers.UpdateGoal)
			// goals.DELETE("/:id", handlers.DeleteGoal)
			// goals.GET("/:id/children", handlers.GetGoalChildren)
		}
	}
}
