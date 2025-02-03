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

var quizzCollection *mongo.Collection = configs.GetCollection(configs.DB, "quizz")
var validateGame = validator.New()

func GetQuizzs() gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        var quizz []models.Quizz
        defer cancel()

        results, err := quizzCollection.Find(ctx, bson.M{})

        if err != nil {
            c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        //reading from the db in an optimal way
        defer results.Close(ctx)
        for results.Next(ctx) {
            var singleQuizz models.Quizz
            if err = results.Decode(&singleQuizz); err != nil {
                c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            }

            quizz = append(quizz, singleQuizz)
        }

        c.JSON(http.StatusOK,
            responses.QuizzResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": quizz}},
        )
    }
}

func GetQuizz() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		quizzId := c.Param("quizzId")

		var quizz models.Quizz
		defer cancel()
		objId, _ := primitive.ObjectIDFromHex(quizzId)

		err := quizzCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&quizz)
		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
		}	

		c.JSON(http.StatusOK, responses.QuizzResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": quizz}})
	}
}

func CreateQuizz() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		var quizz models.Quizz
		defer cancel()

		//validate the request
		if err := c.BindJSON(&quizz); err != nil {
			c.JSON(http.StatusBadRequest, responses.QuizzResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
		}

		//validate fields
        if validationErr := validateGame.Struct(&quizz); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.QuizzResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

		newQuizz := models.Quizz{
			Id: primitive.NewObjectID(),
			Question: quizz.Question,
			CorrectAnswer: quizz.CorrectAnswer,
			WrongAnswer: quizz.WrongAnswer,
		}

		result, err := quizzCollection.InsertOne(ctx, newQuizz)
		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
			return
		}

		c.JSON(http.StatusCreated, responses.QuizzResponse{Status: http.StatusCreated, Message: "success", Data: map[string]interface{}{"data": result}})
	}
}

func UpdateQuizz() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		quizzId := c.Param("quizzId")
		var quizz models.Quizz
		defer cancel()

		objId, _ := primitive.ObjectIDFromHex(quizzId)

        //validate the request body
        if err := c.BindJSON(&quizz); err != nil {
            c.JSON(http.StatusBadRequest, responses.QuizzResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

        //use the validator library to validate required fields
        if validationErr := validateTeam.Struct(&quizz); validationErr != nil {
            c.JSON(http.StatusBadRequest, responses.QuizzResponse{Status: http.StatusBadRequest, Message: "error", Data: map[string]interface{}{"data": validationErr.Error()}})
            return
        }

		updateQuizz := bson.M{
			"question": quizz.Question,
			"correctAnswer": quizz.CorrectAnswer,
			"wrongAnswer": quizz.WrongAnswer, 
		}
		result, err := quizzCollection.UpdateOne(ctx, bson.M{"_id": objId}, bson.M{"$set": updateQuizz})
	
		if err != nil {
            c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
            return
        }

		if result.MatchedCount == 0 {
			c.JSON(http.StatusNotFound, responses.QuizzResponse{Status: http.StatusNotFound, Message: "error", Data: map[string]interface{}{"data": "quizz not found"}})
			return
		}

		//get updated team details
        var updatedQuizz models.Quizz
        if result.MatchedCount == 1 {
            err := quizzCollection.FindOne(ctx, bson.M{"_id": objId}).Decode(&updatedQuizz)
            if err != nil {
                c.JSON(http.StatusInternalServerError, responses.QuizzResponse{Status: http.StatusInternalServerError, Message: "error", Data: map[string]interface{}{"data": err.Error()}})
                return
            }
        }

        c.JSON(http.StatusOK, responses.QuizzResponse{Status: http.StatusOK, Message: "success", Data: map[string]interface{}{"data": updatedQuizz}})
	}
}