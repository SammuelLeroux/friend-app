import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

import 'purple_logic.dart';

void main() {
  runApp(const PurpleGameApp());
}

class PurpleGameApp extends StatelessWidget {
  const PurpleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      home: const PurpleGame(),
    );
  }
}

class PurpleGame extends StatefulWidget {
  const PurpleGame({super.key});

  @override
  State<PurpleGame> createState() => _PurpleGameState();
}

class _PurpleGameState extends State<PurpleGame> {
  PurpleGameLogic gameLogic = PurpleGameLogic();
  final int maxCardsToDraw = 9;

  @override
  void initState() {
    super.initState();
    gameLogic.resetDeck();
  }

  void resetGame() {
    setState(() {
      gameLogic.resetGame();
    });
  }

  void drawCard() {
    setState(() {
      gameLogic.drawCard();
    });
  }

  void resetCardsToDrawForColor(String color) {
    setState(() {
      gameLogic.cardsToDraw = 1;
    });
  }

  void showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Select Options",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: gameLogic.selectedColor,
                onChanged: (String? newValue) {
                  setState(() {
                    gameLogic.selectedColor = newValue!;
                    gameLogic.cardsToDraw = 1;
                  });
                },
                items: <String>['Red', 'Black', 'Purple']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Cards',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  int? inputNumber = int.tryParse(value);
                  if (inputNumber != null && inputNumber > 0) {
                    setState(() {
                      gameLogic.cardsToDraw =
                          (gameLogic.selectedColor == 'Purple' &&
                                  inputNumber > 5)
                              ? 5
                              : (inputNumber > maxCardsToDraw)
                                  ? maxCardsToDraw
                                  : inputNumber;
                    });
                  } else {
                    setState(() {
                      gameLogic.cardsToDraw = 1;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      drawCard();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(126, 113, 102, 114),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      "Draw Card(s)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  PlayingCard convertToPlayingCard(String card) {
    CardValue rank;
    Suit suit;

    switch (card[0]) {
      case 'A':
        rank = CardValue.ace;
        break;
      case '2':
        rank = CardValue.two;
        break;
      case '3':
        rank = CardValue.three;
        break;
      case '4':
        rank = CardValue.four;
        break;
      case '5':
        rank = CardValue.five;
        break;
      case '6':
        rank = CardValue.six;
        break;
      case '7':
        rank = CardValue.seven;
        break;
      case '8':
        rank = CardValue.eight;
        break;
      case '9':
        rank = CardValue.nine;
        break;
      case '1':
        rank = CardValue.ten;
        break;
      case 'J':
        rank = CardValue.jack;
        break;
      case 'Q':
        rank = CardValue.queen;
        break;
      case 'K':
        rank = CardValue.king;
        break;
      default:
        rank = CardValue.two;
    }

    switch (card[card.length - 1]) {
      case 'C':
        suit = Suit.clubs;
        break;
      case 'D':
        suit = Suit.diamonds;
        break;
      case 'H':
        suit = Suit.hearts;
        break;
      case 'S':
        suit = Suit.spades;
        break;
      default:
        suit = Suit.clubs;
    }

    return PlayingCard(suit, rank);
  }

  void drawColorCard(String color) {
    setState(() {
      resetCardsToDrawForColor(color);
      gameLogic.selectedColor = color;
      gameLogic.drawCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purple Game"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.08,
            image: AssetImage('lib/assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                "Previous Points: ${gameLogic.previousPoints}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "Points: ${gameLogic.playerPoints}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 12.0,
                    children: gameLogic.drawnCards.map((card) {
                      return SizedBox(
                        width: 150, 
                        height: 225, 
                        child: PlayingCardView(
                          card: convertToPlayingCard(card),
                          showBack: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton('Red', Colors.red),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton('Black', Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton('Purple', Colors.purple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildButton(
                        'Draw Card(s)', const Color.fromARGB(255, 230, 108, 20),
                        onTap: showColorPickerDialog),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, {Function()? onTap}) {
    EdgeInsetsGeometry buttonMargin = label == 'Draw Card(s)'
        ? const EdgeInsets.only(bottom: 12.0)
        : EdgeInsets.zero;

    return Container(
      margin: buttonMargin,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ?? () => drawColorCard(label),
        borderRadius: BorderRadius.circular(12.0),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
