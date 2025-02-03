package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Action struct {
	Id       primitive.ObjectID `json:"_id,omitempty" bson:"_id"`
	Type     string             `json:"type,omitempty" validate:"required" bson:"type"`
	Sentence string             `json:"sentence,omitempty" validate:"required" bson:"sentence"`
	IdUser   primitive.ObjectID `json:"id_user,omitempty" bson:"id_user"`
	Category string             `json:"category,omitempty" bson:"category"`
	Drink    int                `json:"drink,omitempty" bson:"drink"`
}
