import 'package:flutter/material.dart';

class TurnPopup extends StatelessWidget {
  final String playerName;

  const TurnPopup({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tour du joueur'),
      content: Text('$playerName, c\'est à vous de jouer !'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
