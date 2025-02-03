package routes

import (
    "github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
    "github.com/gin-gonic/gin"
)

func TeamRoute(router *gin.Engine) {
    router.GET("api/team/:userId", controllers.GetTeam())
    router.GET("api/team", controllers.GetTeams())
    router.POST("api/team", controllers.CreateTeam())
    router.PUT("api/team/:teamId", controllers.UpdateTeam())
    router.DELETE("api/team/:teamId", controllers.DeleteTeam())
    router.POST("api/team/:teamId/player", controllers.AddPlayer())
    router.DELETE("api/team/:teamId/player/:playerName", controllers.RemovePlayer())
    router.PUT("api/team/:teamId/player/:playerName", controllers.EditPlayer())
}