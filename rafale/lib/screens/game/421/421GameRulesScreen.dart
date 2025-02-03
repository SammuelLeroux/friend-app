import 'package:flutter/material.dart';
import 'package:rafale/models/player421_model.dart';
import 'package:rafale/screens/game/421/421GameScreen.dart';

class Rules421Screen extends StatelessWidget {
  final List<String> playerNames;

  const Rules421Screen({super.key, required this.playerNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Règles du 421'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Les règles du 421',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '''
Le but du jeu est de réaliser des combinaisons afin de faire grossir la cagnotte que boira le joueur ayant fait le pire score.

Combinaisons:
- 3 x le même Dé = 6 gorgées
- Suite = 5 gorgées
- Double 1 + dé = nombre de gorgées égal au montant du dé
- 4-2-1 = 9 gorgées

Fonctionnement:
- Le premier joueur lance les dés et dispose d’au maximum 3 lancers.
- Il peut choisir de relancer le(s) dé(s) de son choix à chaque lancer.
- Le premier joueur peut s’arrêter dès qu’il le souhaite si son lancer lui convient.
- Le nombre de lancers utilisé par le premier joueur détermine le nombre maximum de lancers des autres joueurs.

Sanctions:
- Le perdant est celui qui aura le score le plus bas.
                ''',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game421Screen(
                          players: playerNames.map((name) => Player421(name: name)).toList(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Commencer le jeu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
