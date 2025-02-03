package routes

import (
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/gin-gonic/gin"
)

func QuizzRoute(router *gin.Engine)  {
    router.GET("api/quizz/:quizzId", controllers.GetQuizz()) 
	router.GET("api/quizz", controllers.GetQuizzs())
	router.POST("api/quizz", controllers.CreateQuizz())
	router.PUT("api/quizz/:quizzId", controllers.UpdateQuizz())
}