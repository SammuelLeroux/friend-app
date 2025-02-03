import 'dart:math';
import 'package:playing_cards/playing_cards.dart';
import 'package:rafale/models/card99_model.dart';
import 'package:rafale/models/player99_model.dart';

class Game99Logic {
  final List<Player99> players;
  final List<Card99Model> deck;
  int currentPlayerIndex = 0;
  int currentCount = 0;
  int penaltyCount = 0;
  final Random random = Random();

  Game99Logic(List<String> playerNames)
      : players = playerNames
            .map((name) => Player99(name: name, hand: []))
            .toList(growable: false),
        deck = _generateDeck() {
    _shuffleDeck();
    _dealCards();
  }

  static List<Card99Model> _generateDeck() {
    List<Card99Model> deck = [];
    for (var suit in Suit.values) {
      for (var value in CardValue.values) {
        deck.add(Card99Model(
          card: PlayingCard(suit, value),
        ));
      }
    }
    return deck;
  }

  void _shuffleDeck() {
    deck.shuffle(random);
  }

  void _dealCards() {
    for (var player in players) {
      player.hand = List.generate(2, (index) => deck.removeLast());
    }
  }

  Player99 getCurrentPlayer() {
    return players[currentPlayerIndex];
  }

  Player99 getNextPlayer() {
    return players[(currentPlayerIndex + 1) % players.length];
  }

  void startTurn() {
    currentPlayerIndex = currentPlayerIndex % players.length;
  }

  void endTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  void playCard(Player99 player, Card99Model card, int declaredCount) {
    player.hand.remove(card);
    int actualCardValue = getCardValue(card);
    currentCount += actualCardValue;

    int totalPenalties = 0;

    if (currentCount != declaredCount) {
      totalPenalties += 2;
    }

    if (player.hand.length < 2) {
      totalPenalties += 2;
    }

    if (totalPenalties > 0) {
      player.penaltyCount += totalPenalties;
      penaltyCount += totalPenalties;
    }
  }

  int getCardValue(Card99Model card) {
    switch (card.card.value) {
      case CardValue.two:
        return 2;
      case CardValue.three:
        return 3;
      case CardValue.four:
        return 4;
      case CardValue.five:
        return 5;
      case CardValue.six:
        return 6;
      case CardValue.seven:
        return 7;
      case CardValue.eight:
        return 8;
      case CardValue.nine:
        return 9;
      case CardValue.ten:
        return 10;
      case CardValue.jack:
        return 11;
      case CardValue.queen:
        return 12;
      case CardValue.king:
        return 13;
      case CardValue.ace:
        return 1;
      case CardValue.joker_1:
        return 0;
      default:
        return 0;
    }
  }

  void drawCard(Player99 player) {
    if (player.hand.length < 3 && deck.isNotEmpty) {
      player.hand.add(deck.removeLast());
    }
  }

  void incrementPenaltyForAskingCount(Player99 player) {
    player.penaltyCount += 2;
    penaltyCount += 2;
  }

  List<String> applyPenalties(Player99 player) {
    List<String> penaltyMessages = [];

    if (currentCount % 10 == 0) {
      int gorgees = currentCount ~/ 10;
      penaltyMessages.add('Distribuez $gorgees gorgées.');
    }
    if (penaltyCount > 0) {
      penaltyMessages.add('${player.name} a $penaltyCount pénalités.');
    }

    if (penaltyMessages.isNotEmpty) {
      penaltyCount = 0; 
    }

    return penaltyMessages;
  }
}
