package main

import (
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/configs"
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	//run database
	configs.ConnectDB()

	println(controllers.GetRandomPlaylistTracks())

	//run routes
	routes.UserRoute(router)
	routes.TeamRoute(router)
	routes.QuizzRoute(router)
	routes.ActionRoute(router)
	routes.BlindTestRoute(router)
	routes.BusRoute(router)

	router.Run("0.0.0.0:" + configs.EnvPort())
}
