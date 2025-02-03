import 'package:flutter/material.dart';
import 'package:rafale/models/player421_model.dart';

class Game421ResultsScreen extends StatelessWidget {
  final List<Player421> players;
  final int cagnotte;

  const Game421ResultsScreen({super.key, required this.players, required this.cagnotte});

  @override
  Widget build(BuildContext context) {
    List<Player421> sortedPlayers = List.from(players)
      ..sort((a, b) => b.score.compareTo(a.score)); // Trier les joueurs par score décroissant

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats du 421'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Classement final',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: sortedPlayers.map((player) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${sortedPlayers.indexOf(player) + 1}. ${player.name} : ${player.score} points',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Cagnotte finale : $cagnotte gorgées',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Retour à l'écran précédent
                },
                child: const Text('Retour au menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
