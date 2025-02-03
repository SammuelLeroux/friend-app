package routes

import (
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/gin-gonic/gin"
)

func ActionRoute(router *gin.Engine) {
	router.GET("api/action/:actionId", controllers.GetAction())
	router.GET("api/action/all/:idUser", controllers.GetAllByIdUser())
	router.GET("api/action/all/category/:category", controllers.GetAllByCategory())
	router.GET("api/action/dare", controllers.GetDare())
	router.GET("api/action/truth", controllers.GetTruth())
	router.GET("api/action", controllers.GetActions())
	router.POST("api/action", controllers.CreateAction())
	router.PUT("api/action/:actionId", controllers.UpdateAction())
}
