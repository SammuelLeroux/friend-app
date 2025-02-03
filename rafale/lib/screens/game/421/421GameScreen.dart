import 'package:flutter/material.dart';
import 'package:rafale/screens/game/421/421GameLogic.dart';
import 'package:rafale/models/player421_model.dart';
import 'package:rafale/screens/game/421/421GameResultatScreen.dart';

class Game421Screen extends StatefulWidget {
  final List<Player421> players;

  const Game421Screen({super.key, required this.players});

  @override
  _Game421ScreenState createState() => _Game421ScreenState();
}

class _Game421ScreenState extends State<Game421Screen> {
  late Game421 game421;

  @override
  void initState() {
    super.initState();
    game421 = Game421(widget.players);
  }

  void _rollDice() {
    setState(() {
      game421.rollDice();
    });
  }

  void _endTurn() {
    if (game421.isRoundOver()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Game421ResultsScreen(
            players: widget.players,
            cagnotte: game421.cagnotte,
          ),
        ),
      );
    } else {
      setState(() {
        game421.nextPlayer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Player421 currentPlayer = widget.players[game421.currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu du 421 - Tour de ${currentPlayer.name}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cagnotte : ${game421.cagnotte} gorgées',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Tour de ${currentPlayer.name}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: game421.dice.map((die) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$die',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: game421.isPlayerTurnOver() ? null : _rollDice,
            child: const Text('Lancer les dés'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: game421.currentPlayerIndex == 0 || game421.isPlayerTurnOver()
                ? _endTurn
                : null,
            child: const Text('Fin de tour'),
          ),
          const SizedBox(height: 20),
          Text(
            'Score de ${currentPlayer.name} : ${currentPlayer.score}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
