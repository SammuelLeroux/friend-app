package models

type Bus struct {
    Name		  string `json:"name,omitempty" validate:"required" bson:"name"`
	Latitude1	  float64 `json:"latitude1,omitempty" validate:"required" bson:"latitude1"`
	Longitude1	  float64 `json:"longitude1,omitempty" validate:"required" bson:"longitude1"`
	Latitude2	  float64 `json:"latitude2,omitempty" validate:"required" bson:"latitude2"`
	Longitude2	  float64 `json:"longitude2,omitempty" validate:"required" bson:"longitude2"`
}