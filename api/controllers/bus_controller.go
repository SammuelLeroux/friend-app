package controllers

import (
	"github.com/umahmood/haversine"
	"github.com/gin-gonic/gin"
	"net/http"
	"math"

	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/models"
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/responses"
)

func CalculateDistance(latitude1 float64,longitude1 float64,latitude2 float64,longitude2 float64) float64{

		destination1 := haversine.Coord{Lat: latitude1, Lon: longitude1}
		destination2 := haversine.Coord{Lat: latitude2, Lon: longitude2}

		_, km := haversine.Distance(destination1, destination2)

		return km
}

// mise à l'échelle de la distance entre deux points
func CalculNbCarte() gin.HandlerFunc {
	return func(c *gin.Context) {
		var bus models.Bus
		var nbCarte float64
		var nbCheckpoint int

		// Validate the request
		if err := c.BindJSON(&bus); err != nil {
			c.JSON(http.StatusBadRequest, responses.BusResponse{
				Status:  http.StatusBadRequest,
				Message: "error",
				Data:    map[string]interface{}{"data : ": err.Error()},
			})
			return
		}

		// valeur passé en paramètre
		latitude1 := bus.Latitude1
		longitude1 := bus.Longitude1
		latitude2 := bus.Latitude2
		longitude2 := bus.Longitude2

		if latitude1 == 365.0 || latitude2 == 365.0 {
			nbCarte = 20
		}else {
			// Calculer la distance entre les deux points
			km := CalculateDistance(latitude1, longitude1, latitude2, longitude2)

			// Appliquer une transformation logarithmique
			//log1p(x) = log(1 + x)
			logDistance := math.Log1p(km)

			// Définir la plage des valeurs transformées
			minLogDistance := 0.0               // log1p(0) = 0
			maxLogDistance := math.Log1p(20000) // log1p(max_distance_possible)

			// Mapper la distance transformée à une valeur entre 5 et 20
			scaledValue := 5 + ((logDistance - minLogDistance) * (20 - 5) / (maxLogDistance - minLogDistance))

			// S'assurer que la valeur est au minimum de 5
			if scaledValue < 5 {
				scaledValue = 5
			}

			// Arrondir au multiple de 5 le plus proche
			nbCarte = 5 * math.Round(scaledValue/5)
		}
		
		switch nbCarte {
		case 5:
			nbCheckpoint = 0
		case 10:
			nbCheckpoint = 1
		case 15:
			nbCheckpoint = 2
		case 20:
			nbCheckpoint = 3
		default:
			nbCheckpoint = 0
		}

		c.JSON(http.StatusOK, responses.BusResponse{
			Status:  http.StatusOK,
			Message: "success",
			Data:    map[string]interface{}{"nbCarte": nbCarte,"nbCheckpoint": nbCheckpoint},
		})
	}
}
	
