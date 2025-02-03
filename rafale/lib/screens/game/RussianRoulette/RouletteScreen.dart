import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rafale/models/playerRoulette_model.dart';

class RouletteRusseScreen extends StatefulWidget {
  final List<PlayerRoulette> players;

  const RouletteRusseScreen({super.key, required this.players});

  @override
  _RouletteRusseScreenState createState() => _RouletteRusseScreenState();
}

class _RouletteRusseScreenState extends State<RouletteRusseScreen> {
  late PlayerRoulette currentPlayer;
  int currentPlayerIndex = 0;
  List<String> barillet = ['blanc', 'blanc', 'balle', 'balle', 'balle'];
  String resultMessage = '';
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.players[currentPlayerIndex];
    barillet.shuffle(); 
  }

  void nextTurn() {
    setState(() {
      if (currentPlayerIndex == 0) {
        currentPlayerIndex = 1;
      } else {
        currentPlayerIndex = 0;
      }
      currentPlayer = widget.players[currentPlayerIndex];
    });
  }

  void tirerSurSoitMeme() {
    setState(() {
      if (barillet.isEmpty) {
        recharger();
      }

      String balle = barillet.removeLast();

      if (balle == 'balle') {
        currentPlayer.health -= 1;
        resultMessage = "C'était une vraie balle ! ${currentPlayer.name} perd 1 point de vie.";
        if (currentPlayer.health <= 0) {
          gameOver = true;
          resultMessage = "${currentPlayer.name} est mort. Fin du jeu.";
        }
      } else {
        resultMessage = "C'était une balle à blanc ! ${currentPlayer.name} garde la main.";
      }

      if (!gameOver) {
        return;
      } else {
        nextTurn(); 
      }
    });
  }

  void tirerSurAdversaire() {
    setState(() {
      if (barillet.isEmpty) {
        recharger();
      }

      String balle = barillet.removeLast();
      PlayerRoulette adversaire = widget.players[currentPlayerIndex == 0 ? 1 : 0];

      if (balle == 'balle') {
        adversaire.health -= 1;
        resultMessage = "${currentPlayer.name} a tiré sur ${adversaire.name} ! ${adversaire.name} perd 1 point de vie.";
        if (adversaire.health <= 0) {
          gameOver = true;
          resultMessage = "${adversaire.name} est mort. Fin du jeu.";
        }
      } else {
        resultMessage = "${currentPlayer.name} a tiré sur ${adversaire.name} mais c'était une balle à blanc.";
      }

      nextTurn(); 
    });
  }

  void utiliserPouvoir(String pouvoir) {
    setState(() {
      if (pouvoir == 'Soigner') {
        currentPlayer.health = min(currentPlayer.health + 1, 5);
        resultMessage = "${currentPlayer.name} utilise 'Soigner' et regagne 1 point de vie.";
      } else if (pouvoir == 'Double Dégâts') {
        barillet = barillet.map((balle) => balle == 'balle' ? 'double-balle' : balle).toList();
        resultMessage = "${currentPlayer.name} utilise 'Double Dégâts'!";
      } else if (pouvoir == 'Voir Balle') {
        String prochaineBalle = barillet.isNotEmpty ? barillet.last : "Aucune balle dans le barillet";
        resultMessage = "${currentPlayer.name} utilise 'Voir Balle'. Prochaine balle: $prochaineBalle";
      }

      currentPlayer.useAbility(pouvoir); 
    });
  }

  void recharger() {
    setState(() {
      barillet = ['blanc', 'blanc', 'balle', 'balle', 'balle'];
      barillet.shuffle();
      resultMessage = "Rechargement de l'arme...";
      for (var player in widget.players) {
        player.addAbility(_getRandomAbility());
      }
    });
  }

  String _getRandomAbility() {
    List<String> abilities = ['Double Dégâts', 'Voir Balle', 'Soigner'];
    abilities.shuffle();
    return abilities.first;
  }

  Widget buildHealthIndicator(PlayerRoulette player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5, 
        (index) => Icon(
          index < player.health ? Icons.favorite : Icons.favorite_border,
          color: index < player.health ? const Color.fromARGB(255, 255, 17, 0) : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette Russe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: widget.players.map((player) {
                return Column(
                  children: [
                    Text(
                      '${player.name} - Vie: ${player.health}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    buildHealthIndicator(player),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              '${currentPlayer.name}, c\'est à toi de jouer!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            if (currentPlayer.abilities.isNotEmpty)
              ElevatedButton(
                onPressed: () => utiliserPouvoir(currentPlayer.abilities.first),
                child: Text('Utiliser pouvoir: ${currentPlayer.abilities.first}'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: tirerSurSoitMeme,
              child: const Text('Tirer sur soi-même'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: tirerSurAdversaire,
              child: const Text('Tirer sur l\'adversaire'),
            ),
            const SizedBox(height: 16),
            Text(
              resultMessage,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            if (gameOver)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retourner au menu principal'),
              ),
          ],
        ),
      ),
    );
  }
}
