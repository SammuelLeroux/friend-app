## Rafale
Rafale est une application mobile développée avec Flutter qui propose des mini-jeux de soirée pour rendre vos soirées entre amis encore plus amusantes. L'application s'appuie sur une API écrite en Go pour gérer les différents jeux et fonctionnalités.

### Fonctionnalités
- 🎮 Collection de mini-jeux de soirée.
- 🌐 API en Go pour la gestion des jeux et des données.
- 📱 Application mobile Flutter avec une interface intuitive et conviviale.
### Prérequis
Avant de commencer, assurez-vous d'avoir installé les éléments suivants :

- Flutter
- Go
- Android Studio avec un émulateur Android configuré.
Installation
Suivez les étapes ci-dessous pour configurer et exécuter le projet sur votre machine locale.

- 1 Cloner le dépôt
Clonez ce dépôt Git en utilisant la commande suivante :

```bash
git clone https://github.com/EpitechMscProPromo2026/T-YEP-600-STG_12.git
```
- 2 L'API doit être lancée avant de démarrer l'application Flutter. Suivez ces étapes :

Accédez au répertoire api :

```bash
cd api
```
Exécutez l'API avec la commande suivante :

```bash
go run main.go
```
L'API devrait maintenant être active et prête à répondre aux requêtes de l'application Flutter.

- 3 Lancer l'application Flutter
Revenez à la racine du projet :

```bash
cd ..
```

Assurez-vous que votre émulateur Android est configuré et lancé.

Lancez le mode débogage pour démarrer l'application Flutter :

```bash
flutter run
```
Vous pouvez également utiliser le bouton "Start Debugging" dans Visual Studio Code pour démarrer l'application sur l'émulateur.
