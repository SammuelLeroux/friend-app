import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dice_icons/dice_icons.dart';

class QodLogic with ChangeNotifier {
  late AnimationController controller;
  final Random _random = Random();
  int diceOneValue = 0;
  int diceTwoValue = 0;
  int? enteredNumber;
  bool isDouble = false;

  QodLogic(TickerProvider vsync) {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  IconData getDiceIcon(int value) {
    switch (value) {
      case 0:
        return DiceIcons.dice0;
      case 1:
        return DiceIcons.dice1;
      case 2:
        return DiceIcons.dice2;
      case 3:
        return DiceIcons.dice3;
      case 4:
        return DiceIcons.dice4;
      case 5:
        return DiceIcons.dice5;
      case 6:
        return DiceIcons.dice6;
      default:
        return DiceIcons.dice0;
    }
  }

  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Result'),
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

  void rollDice(int enteredNumber, bool singleDice, BuildContext context) {
    this.enteredNumber = enteredNumber;
    isDouble = false;

    controller
      ..reset()
      ..forward().then((_) {
        diceOneValue = _random.nextInt(6) + 1;
        diceTwoValue = singleDice ? 0 : _random.nextInt(6) + 1;
        int diceTotal = diceOneValue + diceTwoValue;

        if (diceTotal == enteredNumber) {
          isDouble = true;
          if (singleDice) {
            _showResultDialog(context,
                'Congratulations! You guessed the correct number with a single die.');
          } else {
            _showResultDialog(context,
                'Congratulations! You can now give $enteredNumber shots to someone.');
          }
        } else {
          int shotsToDrink = (enteredNumber - diceTotal).abs();
          _showResultDialog(
              context, 'Sorry! You need to drink $shotsToDrink shots.');
        }

        notifyListeners();
      });
  }

  void resetGame() {
    diceOneValue = 0;
    diceTwoValue = 0;
    enteredNumber = null;
    isDouble = false;
    notifyListeners();
  }
}
