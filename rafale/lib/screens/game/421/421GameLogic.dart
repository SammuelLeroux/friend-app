import 'dart:math';
import 'package:rafale/models/player421_model.dart';

class Game421 {
  final List<Player421> players;
  int currentPlayerIndex = 0;
  List<int> dice = [1, 1, 1]; // Initialisation par défaut
  int maxRolls = 3; // Le nombre maximum de lancers pour le premier joueur
  int currentRolls = 0; // Compteur de lancers pour le joueur actuel
  int cagnotte = 0;
  int roundsCompleted = 0; // Compteur de tours

  Game421(this.players);

  // Lancer les dés
  void rollDice() {
    if (currentRolls < maxRolls) {
      var rng = Random();
      for (int i = 0; i < dice.length; i++) {
        dice[i] = rng.nextInt(6) + 1; // Génère un nombre entre 1 et 6
      }
      currentRolls += 1; // Incrémenter le compteur de lancers
      updateScore(); // Mettre à jour le score après chaque lancer
    }
  }

  // Calculer le score et la cagnotte selon les règles
  void updateScore() {
    players[currentPlayerIndex].score = dice.reduce((a, b) => a + b); // Somme des dés
    int roundCagnotte = calculateCagnotte(dice);
    cagnotte += roundCagnotte;
  }

  int calculateCagnotte(List<int> dice) {
    dice.sort(); // Pour faciliter la vérification des combinaisons

    if (dice[0] == dice[1] && dice[1] == dice[2]) {
      return 6; // 3 dés identiques
    } else if (dice[0] == 4 && dice[1] == 2 && dice[2] == 1) {
      return 9; // Combinaison 4-2-1
    } else if (dice[0] == 1 && dice[1] == 2 && dice[2] == 3) {
      return 5; // Suite
    } else if (dice[0] == 1 && dice[1] == 1) {
      return dice[2]; // Double 1 + dé
    } else {
      return 0; // Pas de combinaison, pas de cagnotte
    }
  }

  // Passer au joueur suivant
  void nextPlayer() {
    if (currentPlayerIndex == 0) {
      maxRolls = currentRolls; // Définir le nombre maximum de lancers pour les autres joueurs
    }
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    currentRolls = 0; // Réinitialiser le compteur de lancers pour le prochain joueur

    if (currentPlayerIndex == 0) {
      roundsCompleted += 1; // Incrémenter le compteur de tours après que tous les joueurs aient joué
    }
  }

  // Vérifier si le joueur a atteint le nombre maximum de lancers
  bool isPlayerTurnOver() {
    return currentRolls >= maxRolls;
  }

  // Vérifier si la manche est terminée pour tous les joueurs
  bool isRoundOver() {
    return roundsCompleted > 0 && currentPlayerIndex == 0;
  }

  // Réinitialiser la manche
  void resetRound() {
    currentPlayerIndex = 0;
    cagnotte = 0;
    currentRolls = 0;
    roundsCompleted = 0;
    for (var player in players) {
      player.score = 0; // Réinitialiser le score pour chaque joueur
    }
  }
}
