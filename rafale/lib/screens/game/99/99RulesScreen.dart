import 'package:flutter/material.dart';
import 'package:rafale/screens/game/99/99GameScreen.dart';
import 'package:rafale/utils/app_colors.dart';

class Game99RulesScreen extends StatelessWidget {
  final List<String> playerNames;

  const Game99RulesScreen({super.key, required this.playerNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu 99 - Règles'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 255, 205, 115), 
              AppColors.deepLemon,
            ],
          ),
        ),
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Les règles du 99',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mise en place\n'
                  'Distribuez 2 cartes à chaque joueur. (Ils doivent en avoir 2 tout le long de la partie).\n\n'
                  'Fonctionnement\n'
                  'L’objectif du jeu est d’arriver à un « compte » de 99.\n'
                  'Tour à tour, les joueurs doivent poser une carte et tenir le compte à voix haute.\n\n'
                  'Valeurs des cartes\n'
                  'De 2 à 10 : les cartes valent leurs valeurs\n'
                  'Valet : -10\n'
                  'Dame : le sens du jeu change\n'
                  'Roi : le compte va jusqu’à 70 ou retourne à 70\n'
                  'AS : 1 ou 11 (au choix du joueur)\n'
                  'Joker : choix du chiffre entre 1 et 9\n\n'
                  'Sanctions\n'
                  'Si un joueur ne pioche pas avant que le joueur suivant joue, il boit 2 gorgées.\n\n'
                  'Si un joueur se trompe dans le calcul du compte, il boit 2 gorgées.\n\n'
                  'Si un joueur demande quel est le compte, il boit 2 gorgées.\n\n'
                  'Un joueur peut distribuer des gorgées lorsque le compte arrive à une dizaine pile (10, 20, 30…).\n'
                  'Il distribue le nombre de gorgées de la dizaine. Par exemple (60 = 6 gorgées).\n\n'
                  'Fin de partie\n'
                  'Le joueur qui arrive à 99 distribue un cul sec.\n\n'
                  'Le joueur qui dépasse 99 doit boire 2 gorgées + le montant dépassé en gorgées (105 = 2 + 6 = 8 gorgées).',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Game99Screen(playerNames: playerNames),
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
      ),
    );
  }
}
