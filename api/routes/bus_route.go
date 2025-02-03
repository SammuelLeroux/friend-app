package routes

import (
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/gin-gonic/gin"
)

func BusRoute(router *gin.Engine)  {
	router.POST("/api/bus", controllers.CalculNbCarte())
}