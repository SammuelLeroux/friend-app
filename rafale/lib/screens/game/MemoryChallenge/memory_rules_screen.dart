import 'package:flutter/material.dart';
import 'package:rafale/models/player.dart';
import 'package:rafale/screens/game/MemoryChallenge/memory_game_screen.dart';
import 'package:rafale/utils/app_colors.dart';

class MemoryRulesScreen extends StatelessWidget {
  final List<Player> players;

  const MemoryRulesScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Challenge - Règles'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 241, 166, 155),
              AppColors.deepLemon,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Règles du jeu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Le but du jeu est de trouver toutes les paires de cartes identiques.\n'
                '2. Chaque joueur, à tour de rôle, retourne deux cartes.\n'
                '3. Si les cartes sont identiques, elles restent retournées et le joueur marque un point.\n'
                '4. Si les cartes ne sont pas identiques, elles sont retournées face cachée et c\'est au tour du joueur suivant.\n'
                '5. Le jeu continue jusqu\'à ce que toutes les paires soient trouvées.\n'
                '6. Le joueur avec le plus de points à la fin du jeu gagne et ne boie pas.\n'
                '7. Les autres joueurs boivent leur différence de point avec le premier',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoryGameScreen(players: players),
                      ),
                    );
                  },
                  child: const Text('Continuer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
