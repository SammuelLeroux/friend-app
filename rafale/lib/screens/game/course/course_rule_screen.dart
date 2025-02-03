import 'package:flutter/material.dart';
import 'package:rafale/screens/game/course/course_choice_screen.dart';
import 'package:rafale/utils/app_colors.dart';

class RulesCourseScreen extends StatefulWidget {
  final List<String> playerNames;
  const RulesCourseScreen({super.key,required this.playerNames});

  @override
  RulesCourseScreenState createState() => RulesCourseScreenState();
}

class RulesCourseScreenState extends State<RulesCourseScreen> {
  void onPressedButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChoiceCourseScreen(playerNames: widget.playerNames)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course de Kro - Règles',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 1),
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 250,
                  ),
                  const SizedBox(height: 1),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Préparation :',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.yellowOrange,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Assurez-vous que tous les joueurs peuvent voir le téléphone.\n'
                          '• Choissisez une Kro pour chaque joueur.\n',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Déroulement :',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.yellowOrange,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Lancez le jeu en appuyant sur le bouton "Play".\n'
                          '• Pariez sur la Kro la plus rapide.\n'
                          '• La dernière bière a franchir la ligne d\'arrivé perd !',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onPressedButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Play !',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
