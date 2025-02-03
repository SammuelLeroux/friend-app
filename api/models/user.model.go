package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type User struct {
    Id          primitive.ObjectID `json:"_id,omitempty" bson:"_id"`
    Username string             `json:"username,omitempty" validate:"required" bson:"username"`
    Email    string             `json:"email,omitempty" validate:"required" bson:"email"`
    Password string             `json:"password,omitempty" validate:"required" bson:"password"`
    Created  primitive.DateTime `json:"created_at,omitempty" bson:"created_at"`
    Updated  primitive.DateTime `json:"updated_at,omitempty" bson:"updated_at"`
    Prenium  *bool              `json:"prenium" validate:"required" bson:"prenium"`
    Phone    string             `json:"phone,omitempty" validate:"required" bson:"phone"`
}