import 'package:flutter/material.dart';
import 'package:rafale/screens/game/course/course_game_screen.dart';

class ChoiceCourseScreen extends StatefulWidget {
  final List<String> playerNames;
  const ChoiceCourseScreen({super.key, required this.playerNames});

  @override
  ChoiceCourseScreenState createState() => ChoiceCourseScreenState();
}

class ChoiceCourseScreenState extends State<ChoiceCourseScreen> {
  List<String?> selectedPlayers = [];
  List<String> availablePlayers = [];
  Map<String, String> playerKro = {
    'Kro rouge': 'bot',
    'Kro jaune': 'bot',
    'Kro bleue': 'bot',
    'Kro violet': 'bot',
  };
  
  @override
  void initState() {
    super.initState();
    availablePlayers = List.from(widget.playerNames);
    selectedPlayers = List.filled(widget.playerNames.length, null);
  }

  void onPlayerSelected(int index, String? selectedPlayer, String hintText) {
    setState(() {
      playerKro[hintText] = selectedPlayer!;
      selectedPlayers[index] = selectedPlayer;
      availablePlayers = widget.playerNames
          .where((player) => !selectedPlayers.contains(player))
          .toList();
    });
  }

  void onPressedButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameCourseScreen(choicePlayer: playerKro)),
    );
  }

  String hintText(int index) {
    switch (index) {
      case 1:
        return 'Kro rouge';
      case 2:
        return 'Kro jaune';
      case 3:
        return 'Kro bleue';
      case 4:
        return 'Kro violet';
      default:
        return 'Select Player';
    }
  }

  int nbChoice() {
    if (widget.playerNames.length < 4) {
      return widget.playerNames.length;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course de Kro - Choix de la Kro',
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < nbChoice(); i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: selectedPlayers[i],
                        hint: Text(hintText(i + 1)),
                        onChanged: (String? newValue) {
                          onPlayerSelected(i, newValue, hintText(i + 1));
                        },
                        items: [
                          if (selectedPlayers[i] != null)
                            DropdownMenuItem<String>(
                              value: selectedPlayers[i],
                              child: Text(selectedPlayers[i]!),
                            ),
                          ...availablePlayers
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: onPressedButton,
                    child: const Text('Commencer la course'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
