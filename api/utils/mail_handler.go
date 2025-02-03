package utils

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"net/smtp"
	"time"

	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/configs"
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

var userCollection *mongo.Collection = configs.GetCollection(configs.DB, "user")
func MailHandler(email string) bool{
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	var user models.User
	defer cancel()

	if err := userCollection.FindOne(ctx, bson.M{"email": email}).Decode(&user); err != nil {
		return true
	}

	return false

}

//use tls connection to send mail
func SendMail(email string) string {

	// Define the SMTP server configuration.
    smtpHost := "smtp.gmail.com"
    smtpPort := "587"
    fromEmail := configs.EnvMailSender()

    toEmails := []string{email} // The recipient's email address.
    auth := smtp.PlainAuth("", fromEmail, configs.EnvPasswordMailSender(), smtpHost)

	// générateur basé sur le temps
	rand.New(rand.NewSource(time.Now().Unix())) 
    code := ""

	// fmt.Sprintf() pour formater une chaîne de caractères
    for i := 0; i < 8; i++ {
        code += fmt.Sprintf("%d", rand.Intn(10)) 
    }

    // Define the email headers and body.
    message := []byte("To: " + email + "\r\n" +
    "Subject: Réinitialisation de votre mot de passe\r\n" +
    "MIME-Version: 1.0\r\n" +
    "Content-Type: text/html; charset=\"UTF-8\"\r\n" +
    "\r\n" +
    "<html><body>" +
    "<h2>Réinitialisation de votre mot de passe</h2>" +
    "<p>Bonjour,</p>" +
    "<p>Vous avez demandé la réinitialisation de votre mot de passe. Veuillez utiliser le code ci-dessous pour créer un nouveau mot de passe :</p>" +
    "<p><b>CODE : " + code + "</b></p>" + 
    "<p>Si vous n'avez pas demandé la réinitialisation de votre mot de passe, veuillez ignorer cet email.</p>" +
    "<p>Merci,</p>" +
    "<p>L'équipe de support</p>" +
    "</body></html>\r\n")

    // Send the email.
    err := smtp.SendMail(smtpHost+":"+smtpPort, auth, fromEmail, toEmails, message)
    if err != nil {
        log.Fatal(err)
    }

	return code
}
