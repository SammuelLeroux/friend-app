import 'package:flutter/material.dart';
import 'package:rafale/screens/game/RussianRoulette/RouletteScreen.dart'; // Assurez-vous d'importer l'écran du mini-jeu
import 'package:rafale/models/playerRoulette_model.dart'; // Importez le modèle de joueur

class RouletteRulesScreen extends StatelessWidget {
  final List<PlayerRoulette> players;

  const RouletteRulesScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Règles du Jeu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Règles de la Roulette Russe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '''1. La Roulette Russe est un duel entre 2 joueurs.
2. Chaque joueur a 3 points de vie.
3. Lors de son tour, un joueur peut tirer sur lui-même ou sur son adversaire.
4. S'il tire sur lui-même :
   - Si c'est une balle à blanc, il ne subit aucun dégât et garde la main.
   - Si c'est une vraie balle, il subit 1 point de dégât et garde la main.
5. S'il tire sur son adversaire :
   - Si c'est une balle à blanc, l'adversaire ne subit aucun dégât et prend la main.
   - Si c'est une vraie balle, l'adversaire subit 1 point de dégât et prend la main.
6. Il y a 5 balles dans le chargeur :
   - 3 vraies balles qui font 1 dégât chacune.
   - 2 balles à blanc qui ne font aucun dégât.
7. Les balles sont tirées aléatoirement du chargeur. Une fois que toutes les balles ont été utilisées, le chargeur est rechargé automatiquement.''',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouletteRusseScreen(players: players),
                  ),
                );
              },
              child: const Text('Commencer le jeu'),
            ),
          ],
        ),
      ),
    );
  }
}
