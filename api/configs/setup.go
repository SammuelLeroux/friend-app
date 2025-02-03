package configs

import (
    "context"
    "fmt"
    "log"
    "os"
    "time"

    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

// ConnectDB initializes and returns a MongoDB client using environment variables for configuration.
func ConnectDB() *mongo.Client {
    // Use the environment variable for MongoDB URI
    mongoURI := EnvMongoURI()
    if mongoURI == "" {
        log.Fatal("DB_URI not found")
    }

    // Connect to MongoDB and return the client
    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()
    client, err := mongo.Connect(ctx, options.Client().ApplyURI(mongoURI))
    if err != nil {
        log.Fatalf("Failed to connect to MongoDB: %v", err)
    }

    // Ping the database to verify connection is successful
    err = client.Ping(ctx, nil)
    if err != nil {
        log.Fatalf("Failed to ping MongoDB: %v", err)
    }

    fmt.Println("Connected to MongoDB")
    return client
}

// DB is a global variable to hold the database connection.
var DB *mongo.Client = ConnectDB()

// GetCollection returns a handle to a MongoDB collection specified by the collectionName parameter.
func GetCollection(client *mongo.Client, collectionName string) *mongo.Collection {
    // It's recommended to use an environment variable or configuration file for the database name.
    databaseName := os.Getenv("DB_NAME")
    if databaseName == "" {
        log.Fatal("DB_NAME not found")
    }

    collection := client.Database(databaseName).Collection(collectionName)
    return collection
}