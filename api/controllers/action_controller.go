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

var actionCollection *mongo.Collection = configs.GetCollection(configs.DB, "truthOrDare")
var validateAction = validator.New()

func GetActions() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var action []models.Action
		defer cancel()

		results, err := actionCollection.Find(ctx, bson.M{})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//reading from the db in an optimal way
		defer results.Close(ctx)
		for results.Next(ctx) {
			var singleAction models.Action
			if err = results.Decode(&singleAction); err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			}

			action = append(action, singleAction)
		}

		c.JSON(http.StatusOK,
			responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}},
		)
	}
}

func GetTruth() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var action []models.Action
		defer cancel()

		results, err := actionCollection.Find(ctx, bson.M{"type": "Truth"})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//reading from the db in an optimal way
		defer results.Close(ctx)
		for results.Next(ctx) {
			var singleAction models.Action
			if err = results.Decode(&singleAction); err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			}

			action = append(action, singleAction)
		}

		c.JSON(http.StatusOK,
			responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}},
		)
	}
}

func GetDare() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var action []models.Action
		defer cancel()

		results, err := actionCollection.Find(ctx, bson.M{"type": "Dare"})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//reading from the db in an optimal way
		defer results.Close(ctx)
		for results.Next(ctx) {
			var singleAction models.Action
			if err = results.Decode(&singleAction); err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			}

			action = append(action, singleAction)
		}

		c.JSON(http.StatusOK,
			responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}},
		)
	}
}

func GetAllByIdUser() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		idUser := c.Param("idUser")

		var action []models.Action
		defer cancel()
		objId, _ := primitive.ObjectIDFromHex(idUser)

		results, err := actionCollection.Find(ctx, bson.M{"idUser": objId})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//reading from the db in an optimal way
		defer results.Close(ctx)
		for results.Next(ctx) {
			var singleAction models.Action
			if err = results.Decode(&singleAction); err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			}

			action = append(action, singleAction)
		}

		c.JSON(http.StatusOK,
			responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}},
		)
	}
}

func GetAllByCategory() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		category := c.Param("category")

		var action []models.Action
		defer cancel()

		results, err := actionCollection.Find(ctx, bson.M{"category": category})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//reading from the db in an optimal way
		defer results.Close(ctx)
		for results.Next(ctx) {
			var singleAction models.Action
			if err = results.Decode(&singleAction); err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			}

			action = append(action, singleAction)
		}

		c.JSON(http.StatusOK,
			responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}},
		)
	}
}

func GetAction() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		actionId := c.Param("actionId")

		var action models.Action
		defer cancel()
		objId, _ := primitive.ObjectIDFromHex(actionId)

		err := actionCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&action)
		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		c.JSON(http.StatusOK, responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": action}})
	}
}

func CreateAction() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var action models.Action
		defer cancel()

		//validate the request
		if err := c.BindJSON(&action); err != nil {
			c.JSON(http.StatusBadRequest, responses.ActionResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//validate fields
		if validationErr := validateGame.Struct(&action); validationErr != nil {
			c.JSON(http.StatusBadRequest, responses.ActionResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
			return
		}

		newAction := models.Action{
			Id:       primitive.NewObjectID(),
			Type:     action.Type,
			Sentence: action.Sentence,
			IdUser:   action.IdUser,
			Category: action.Category,
			Drink:    action.Drink,
		}

		result, err := actionCollection.InsertOne(ctx, newAction)
		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		c.JSON(http.StatusCreated, responses.ActionResponse{Status: http.StatusCreated, Message: "success", Data: map[string]interface{}{"data": result}})
	}
}

func UpdateAction() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		actionId := c.Param("actionId")
		var action models.Action
		defer cancel()

		objId, _ := primitive.ObjectIDFromHex(actionId)

		//validate the request body
		if err := c.BindJSON(&action); err != nil {
			c.JSON(http.StatusBadRequest, responses.ActionResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		//use the validator library to validate required fields
		if validationErr := validateAction.Struct(&action); validationErr != nil {
			c.JSON(http.StatusBadRequest, responses.ActionResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
			return
		}

		UpdateAction := bson.M{
			"sentence": action.Sentence,
			"type":     action.Type,
			"id_user":  action.IdUser,
			"category": action.Category,
		}
		result, err := actionCollection.UpdateOne(ctx, bson.M{"_id": objId}, bson.M{"$set": UpdateAction})

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		if result.MatchedCount == 0 {
			c.JSON(http.StatusNotFound, responses.ActionResponse{Status: http.StatusNotFound, Message: "error", Data: map[string]interface{}{"data": "action not found"}})
			return
		}

		//get updated team details
		var updatedAction models.Action
		if result.MatchedCount == 1 {
			err := actionCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&updatedAction)
			if err != nil {
				c.JSON(http.StatusInternalServerError, responses.ActionResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
				return
			}
		}

		c.JSON(http.StatusOK, responses.ActionResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": updatedAction}})
	}
}
