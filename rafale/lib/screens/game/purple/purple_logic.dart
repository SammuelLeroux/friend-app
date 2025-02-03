import 'dart:math';

class PurpleGameLogic {
  final List<String> fullDeck = [
    '2C',
    '3C',
    '4C',
    '5C',
    '6C',
    '7C',
    '8C',
    '9C',
    '10C',
    'JC',
    'QC',
    'KC',
    'AC',
    '2D',
    '3D',
    '4D',
    '5D',
    '6D',
    '7D',
    '8D',
    '9D',
    '10D',
    'JD',
    'QD',
    'KD',
    'AD',
    '2H',
    '3H',
    '4H',
    '5H',
    '6H',
    '7H',
    '8H',
    '9H',
    '10H',
    'JH',
    'QH',
    'KH',
    'AH',
    '2S',
    '3S',
    '4S',
    '5S',
    '6S',
    '7S',
    '8S',
    '9S',
    '10S',
    'JS',
    'QS',
    'KS',
    'AS'
  ];

  List<String> deck = [];
  List<String> drawnCards = [];
  List<String> redBlackList = [];

  String selectedColor = 'Red';
  int cardsToDraw = 1;
  int playerPoints = 0;
  int previousPoints = 0;

  void resetDeck() {
    deck = List.from(fullDeck)..shuffle(Random());
    drawnCards.clear();
    redBlackList.clear();
  }

  void resetGame() {
    resetDeck();
    previousPoints = playerPoints;
    playerPoints = 0;
    drawnCards.clear();
    redBlackList.clear();
  }

  void drawCard() {
    resetDeck();
    drawnCards.clear();
    redBlackList.clear();
    int actualCardsToDraw =
        (selectedColor == 'Purple') ? cardsToDraw * 2 : cardsToDraw;
    for (int i = 0; i < actualCardsToDraw; i++) {
      if (deck.isEmpty) {
        resetDeck();
      }
      String card = deck.removeLast();
      drawnCards.add(card);
      checkCardColor(card);
    }
    checkGuess();
  }

  void checkCardColor(String card) {
    String lastChar = card.substring(card.length - 1);
    String color = (lastChar == 'C' || lastChar == 'S') ? 'Black' : 'Red';
    redBlackList.add(color);
  }

  void checkGuess() {
    bool isCorrectGuess;
    if (selectedColor == 'Purple') {
      int redCount = redBlackList.where((color) => color == 'Red').length;
      int blackCount = redBlackList.where((color) => color == 'Black').length;
      isCorrectGuess = redCount >= cardsToDraw && blackCount >= cardsToDraw;
    } else {
      isCorrectGuess = redBlackList
          .every((color) => color.toLowerCase() == selectedColor.toLowerCase());
    }
    if (isCorrectGuess) {
      playerPoints += redBlackList.length;
    } else {
      previousPoints = playerPoints;
      playerPoints = 0;
    }
  }
}
