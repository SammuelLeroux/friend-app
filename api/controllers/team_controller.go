package controllers

import (
    "context"
    "net/http"
    "time"

    "github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/configs"
    "github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/models"
    "github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/responses"
    "github.com/gin-gonic/gin"

    "github.com/go-playground/validator/v10"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/bson/primitive"
    "go.mongodb.org/mongo-driver/mongo"
)

var teamCollection *mongo.Collection = configs.GetCollection(configs.DB, "team")
var validateTeam = validator.New()
var validate = validator.New()

func GetTeams() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        var teams []models.Team
        defer cancel()

        results, err := teamCollection.Find(ctx, bson.M{})

        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        //reading from the db in an optimal way
        defer results.Close(ctx)
        for results.Next(ctx) {
            var singleTeam models.Team
            if err = results.Decode(&singleTeam); err != nil {
                c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            }

            teams = append(teams, singleTeam)
        }

        c.JSON(http.StatusOK,
            responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": teams}},
        )
    }
}

func GetTeam() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        defer cancel()

        userId := c.Param("userId")
        var teams []models.Team

        // Convert the userId to an ObjectID
        objId, err := primitive.ObjectIDFromHex(userId)
        if err != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "invalid user ID", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        // Find teams with the given userId
        cursor, err := teamCollection.Find(ctx, bson.M{"idUser": objId})
        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error finding teams", Data: map[string]interface{}{"data": err.Error()}})
            return
        }
        defer cursor.Close(ctx)

        for cursor.Next(ctx) {
            var singleTeam models.Team
            if err = cursor.Decode(&singleTeam); err != nil {
                c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error decoding team", Data: map[string]interface{}{"data": err.Error()}})
                return
            }
            teams = append(teams, singleTeam)
        }

        if err := cursor.Err(); err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "cursor error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        if len(teams) == 0 {
            c.JSON(http.StatusNotFound, responses.TeamResponse{Status: http.StatusNotFound, Message: "no teams found", Data: map[string]interface{}{"data": "no teams found for the given user ID"}})
            return
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": teams}})
    }
}

func CreateTeam() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var team models.Team
		defer cancel()

		//validate the request
		if err := c.BindJSON(&team); err != nil {
			c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
		}

		//validate fields
        if validationErr := validateTeam.Struct(&team); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

		newTeam := models.Team{
			Id: primitive.NewObjectID(),
			IdUser: team.IdUser,
			TeamName: team.TeamName,
			Names: team.Names,     
		}

		result, err := teamCollection.InsertOne(ctx, newTeam)
		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		c.JSON(http.StatusCreated, responses.TeamResponse{Status: http.StatusCreated, Message: "success", Data: map[string]interface{}{"data": result}})
	}
}

func UpdateTeam() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		teamId := c.Param("teamId")
		var team models.Team
		defer cancel()

		objId, _ := primitive.ObjectIDFromHex(teamId)

        //validate the request body
        if err := c.BindJSON(&team); err != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        //use the validator library to validate required fields
        if validationErr := validateTeam.Struct(&team); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

		updateTeam := bson.M{
			"idUser": team.IdUser, 
			"teamName": team.TeamName,
			"names": team.Names, 
		}
		result, err := teamCollection.UpdateOne(ctx, bson.M{"_id": objId}, bson.M{"$set": updateTeam})
	
		if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

		if result.MatchedCount == 0 {
			c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": "no team found with the given id"}})
			return
		}

		//get updated team details
        var updatedTeam models.Team
        if result.MatchedCount == 1 {
            err := teamCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&updatedTeam)
            if err != nil {
                c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
                return
            }
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": updatedTeam}})
	}
}

func DeleteTeam() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        teamId := c.Param("teamId")
        defer cancel()

        objId, _ := primitive.ObjectIDFromHex(teamId)
        result, err := teamCollection.DeleteOne(ctx, bson.M{"_id": objId})

        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        if result.DeletedCount == 0 {
            c.JSON(http.StatusNotFound, responses.TeamResponse{Status: http.StatusNotFound, Message: "error", Data: map[string]interface{}{"data": "no team found with the given id"}})
            return
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": "team deleted successfully"}})
    }
}

func AddPlayer() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        teamId := c.Param("teamId")
        var playerName struct {
            Name string `json:"name" validate:"required"`
        }
        defer cancel()

        objId, _ := primitive.ObjectIDFromHex(teamId)

        // Validate the request body
        if err := c.BindJSON(&playerName); err != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        // Use the validator library to validate required fields
        if validationErr := validate.Struct(&playerName); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

        updateTeam := bson.M{
            "$push": bson.M{"names": playerName.Name},
        }

        result, err := teamCollection.UpdateOne(ctx, bson.M{"_id": objId}, updateTeam)

        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        if result.MatchedCount == 0 {
            c.JSON(http.StatusNotFound, responses.TeamResponse{Status: http.StatusNotFound, Message: "error", Data: map[string]interface{}{"data": "team not found"}})
            return
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusCreated, Message: "success", Data: map[string]interface{}{"data": "player added successfully"}})
    }
}

func RemovePlayer() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        defer cancel()

        teamId := c.Param("teamId")
        teamIdObj, _ := primitive.ObjectIDFromHex(teamId)
        playerName := c.Param("playerName")

        var team models.Team

        // Récupérer l'objet team en fonction de son teamName
        err := teamCollection.FindOne(ctx, bson.M{"_id": teamIdObj}).Decode(&team)
        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        // Parcourir la collection names et supprimer le joueur correspondant
        updatedNames := []string{}
        for _, name := range team.Names {
            if name != playerName {
                updatedNames = append(updatedNames, name)
            }
        }

        // Mettre à jour l'objet team dans la base de données
        update := bson.M{"$set": bson.M{"names": updatedNames}}
        _, err = teamCollection.UpdateOne(ctx, bson.M{"_id": teamIdObj}, update)
        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": "player removed successfully"}})
    }
}

func EditPlayer() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        defer cancel()

        teamId := c.Param("teamId")
        playerId := c.Param("playerName")

        var playerDetails struct {
            Name string `json:"name" validate:"required"`
        }

        objId, _ := primitive.ObjectIDFromHex(teamId)

        // Validate the request body
        if err := c.BindJSON(&playerDetails); err != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        // Use the validator library to validate required fields
        if validationErr := validate.Struct(&playerDetails); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.TeamResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

        // Récupérer l'objet team en fonction de son teamId
        var team models.Team
        err := teamCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&team)
        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        // Mettre à jour le nom du joueur dans la collection names
        updatedNames := []string{}
        for _, name := range team.Names {
            if name == playerId {
                updatedNames = append(updatedNames, playerDetails.Name)
            } else {
                updatedNames = append(updatedNames, name)
            }
        }

        // Mettre à jour l'objet team dans la base de données
        update := bson.M{"$set": bson.M{"names": updatedNames}}
        _, err = teamCollection.UpdateOne(ctx, bson.M{"_id": objId}, update)
        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.TeamResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        c.JSON(http.StatusOK, responses.TeamResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": "player updated successfully"}})
    }
}