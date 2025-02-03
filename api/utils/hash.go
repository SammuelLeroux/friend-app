package utils

import (
    "golang.org/x/crypto/bcrypt"
)

func HashedPassword(password string) string{
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	if err != nil {
		return "Error during password hashing"
	}
    return string(bytes)
}

//retourne true si le mot de passe correspond au hash	
func VerifyPassword(hashedPassword, password string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
    return err == nil 
}
