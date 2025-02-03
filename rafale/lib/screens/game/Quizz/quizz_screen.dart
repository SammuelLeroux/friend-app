import 'package:flutter/material.dart';
import 'package:rafale/screens/game/TruthOrDare/truthOrDare_screen.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:rafale/models/player.dart';

class RulesTruthOrDareScreen extends StatefulWidget {
  final List<Player> players;

  const RulesTruthOrDareScreen({super.key, required this.players});
  @override
  RulesTruthOrDareState createState() => RulesTruthOrDareState();
}

class RulesTruthOrDareState extends State<RulesTruthOrDareScreen> {
  void onPressedButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TruthOrDareScreen(players: widget.players),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizz - Règles'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'lib/assets/logoRafale.png',
              height: 200,
              width: 200,
            ),
            const Text(
              'Action ou vérité',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Vous allez devoir choisir entre deux carte différente,',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const Text(
              'Action ou vérité. Vous devrez réaliser l\'action ou répondre à la question posée.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const Text(
              'Si vous refusez, vous devrez boire 3 gorgées.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Bonne chance !',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            InputChip(
              label: const Text('Play !'),
              onPressed: onPressedButton,
              backgroundColor: AppColors.yellowOrange,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
