package routes

import (
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/gin-gonic/gin"
)

func UserRoute(router *gin.Engine) {
	// Group routes that need authentication
	// protected := router.Group("/api/user")
	// protected.Use(middleware.AuthMiddleware())
	// {
	// 	protected.GET("/:userId", controllers.GetUser())
		
	// }

	// Public routes
	router.POST("api/login", controllers.LoginHandler())
	router.POST("api/mail", controllers.CheckMail())
	router.POST("api/reset", controllers.ResetPassword())
	router.POST("api/user", controllers.CreateUser())
	router.GET("api/user", controllers.GetUsers())
	router.PUT("api/user/:userId", controllers.UpdateUser())
	router.GET("api/user/:userId", controllers.GetUser())
}
