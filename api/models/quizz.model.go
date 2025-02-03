package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Quizz struct {
    Id          primitive.ObjectID `json:"_id,omitempty" bson:"_id"`
    Question      string   `json:"question,omitempty" validate:"required" bson:"question"`
    CorrectAnswer string   `json:"correctAnswer,omitempty" validate:"required" bson:"correctAnswer"`
    WrongAnswer   []string `json:"wrongAnswer,omitempty" validate:"required" bson:"wrongAnswer"`
}