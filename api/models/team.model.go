package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Team struct {
    Id          primitive.ObjectID `json:"_id,omitempty" bson:"_id"`
    IdUser   primitive.ObjectID `json:"idUser,omitempty" validate:"required" bson:"idUser"`
    TeamName string             `json:"teamName,omitempty" validate:"required" bson:"teamName"`
    Names    []string           `json:"names,omitempty" validate:"required" bson:"names"`
}