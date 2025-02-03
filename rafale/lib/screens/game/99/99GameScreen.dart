import 'package:flutter/material.dart';
import 'package:rafale/models/card99_model.dart';
import 'package:rafale/models/player99_model.dart';
import 'package:rafale/providers/99_logic.dart';
import 'package:rafale/widgets/card99_widget.dart';

class Game99Screen extends StatefulWidget {
  final List<String> playerNames;

  const Game99Screen({super.key, required this.playerNames});

  @override
  _Game99ScreenState createState() => _Game99ScreenState();
}

class _Game99ScreenState extends State<Game99Screen> {
  late Game99Logic game;
  late Player99 currentPlayer;
  final TextEditingController _countController = TextEditingController();
  Card99Model? selectedCard;

  @override
  void initState() {
    super.initState();
    game = Game99Logic(widget.playerNames);
    currentPlayer = game.getCurrentPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCurrentPlayerDialog());
  }

  void _showCurrentPlayerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('C\'est le tour de ${currentPlayer.name}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                game.startTurn();
                setState(() {
                  currentPlayer = game.getCurrentPlayer();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _endTurn() {
    setState(() {
      currentPlayer = game.getNextPlayer();
      game.endTurn(); 
    });
    _showCurrentPlayerDialog();
  }

  void _validateTurn() {
    if (selectedCard == null) {
      _showErrorDialog("Vous devez sélectionner une carte pour jouer.");
      return;
    }

    int declaredCount = int.tryParse(_countController.text) ?? 0;
    game.playCard(currentPlayer, selectedCard!, declaredCount);

    List<String> penaltyMessages = game.applyPenalties(currentPlayer);

    setState(() {
      selectedCard = null;
    });

    if (penaltyMessages.isNotEmpty) {
      _showPenaltyDialog(penaltyMessages);
    } else {
      _endTurn();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPenaltyDialog(List<String> penaltyMessages) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sanction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: penaltyMessages.map((message) => Text(message)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _endTurn();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCounterPenalty() {
    game.incrementPenaltyForAskingCount(currentPlayer);
    _showCurrentCountDialog(game.currentCount);
    setState(() {});
  }

  void _showCurrentCountDialog(int count) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Compte actuel'),
          content: Text('Le compte actuel est de $count.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu 99'),
      ),
      body: Column(
        children: [
          Text('C\'est le tour de ${currentPlayer.name}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentPlayer.hand.map((card) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCard = card;
                  });
                },
                child: Opacity(
                  opacity: selectedCard == card ? 0.5 : 1.0,
                  child: Column(
                    children: [
                      Text(game.getCardValue(card).toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.black)),
                      CardWidget(card: card),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          TextField(
            controller: _countController,
            decoration: const InputDecoration(
              labelText: 'Déclarez le compte',
            ),
            keyboardType: TextInputType.number,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _validateTurn,
                    child: const Text('Valider'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.drawCard(currentPlayer);
                      setState(() {});
                    },
                    child: const Text('Piocher une carte'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showCounterPenalty,
                child: const Text('Voir le compteur'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Pénalités de ${currentPlayer.name} : ${currentPlayer.getPenaltyCount}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
