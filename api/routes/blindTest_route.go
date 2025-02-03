package routes

import (
	"net/http"

	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/controllers"
	"github.com/gin-gonic/gin"
)

func BlindTestRoute(router *gin.Engine) {
	router.GET("api/blindtest/tracks", func(c *gin.Context) {
		tracks, err := controllers.GetPlaylistTracks()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, tracks)
	})

	// Utilisez une fonction anonyme pour appeler GetRandomPlaylistTracks et renvoyer son résultat
	router.GET("api/blindtest/randomTracks", func(c *gin.Context) {
		tracks, err := controllers.GetRandomPlaylistTracks()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, tracks)
	})
}
