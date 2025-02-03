import 'dart:math';
import 'package:rafale/models/playerRoulette_model.dart';

class RouletteRusseGame {
  PlayerRoulette player1;
  PlayerRoulette player2;
  PlayerRoulette activePlayer;
  List<int> bullets;

  RouletteRusseGame({required this.player1, required this.player2})
      : activePlayer = player1,
        bullets = _generateBullets() {
    // Donner un pouvoir aléatoire à chaque joueur au début de la partie
    player1.addAbility(_getRandomAbility());
    player2.addAbility(_getRandomAbility());
  }

  static List<int> _generateBullets() {
    List<int> bullets = [1, 1, 1, 0, 0];
    bullets.shuffle(Random());
    return bullets;
  }

  String _getRandomAbility() {
    List<String> abilities = ['Double Dégâts', 'Voir Balle', 'Soigner'];
    abilities.shuffle();
    return abilities.first;
  }

  void recharger() {
    bullets = _generateBullets();
    // Donner un nouveau pouvoir à chaque joueur lors du rechargement
    player1.addAbility(_getRandomAbility());
    player2.addAbility(_getRandomAbility());
  }

  bool shootSelf() {
    if (bullets.isEmpty) return false;
    
    int bullet = bullets.removeLast();

    if (bullet == 1) {
      activePlayer.health -= 1;
    }

    // Le joueur garde toujours la main
    return bullet == 1;
  }

  bool shootOpponent() {
    PlayerRoulette opponent = activePlayer == player1 ? player2 : player1;
    if (bullets.isEmpty) return false;
    int bullet = bullets.removeLast();
    if (bullet == 1) {
      opponent.health -= 1;
    }
    nextTurn();
    return bullet == 1;
  }

  void useAbility(String ability) {
    switch (ability) {
      case 'Double Dégâts':
        // Double les dégâts de la prochaine balle
        break;
      case 'Peek Next Bullet':
        // Regarde la prochaine balle
        break;
      case 'Heal':
        if (activePlayer.health < 3) {
          activePlayer.health += 1;
        }
        break;
    }
    activePlayer.useAbility(ability);
  }

  void nextTurn() {
    activePlayer = (activePlayer == player1) ? player2 : player1;
    if (bullets.isEmpty) {
      recharger();  // Recharger si les balles sont finies et donner des pouvoirs
    }
  }

  bool isGameOver() {
    return !player1.isAlive() || !player2.isAlive();
  }

  String getWinner() {
    if (!player1.isAlive()) return player2.name;
    if (!player2.isAlive()) return player1.name;
    return 'No Winner';
  }
}
