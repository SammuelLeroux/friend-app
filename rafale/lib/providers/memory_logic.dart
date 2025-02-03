import 'package:flutter/foundation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:rafale/models/customplayingcard_model.dart';
import 'package:rafale/models/player.dart';
class MemoryLogic extends ChangeNotifier {
  final List<Player> players;
  List<CustomPlayingCard> cards = [];
  int currentPlayerIndex = 0;
  bool isProcessing = false;

  MemoryLogic({required this.players}) {
    initializeCards();
  }

  void initializeCards() {
    cards = [
      CustomPlayingCard(Suit.hearts, CardValue.ace),
      CustomPlayingCard(Suit.hearts, CardValue.ace),
      CustomPlayingCard(Suit.spades, CardValue.ace),
      CustomPlayingCard(Suit.spades, CardValue.ace),
      CustomPlayingCard(Suit.hearts, CardValue.queen),
      CustomPlayingCard(Suit.hearts, CardValue.queen),
      CustomPlayingCard(Suit.spades, CardValue.queen),
      CustomPlayingCard(Suit.spades, CardValue.queen),
      CustomPlayingCard(Suit.hearts, CardValue.king),
      CustomPlayingCard(Suit.hearts, CardValue.king),
      CustomPlayingCard(Suit.spades, CardValue.king),
      CustomPlayingCard(Suit.spades, CardValue.king),
      CustomPlayingCard(Suit.hearts, CardValue.jack),
      CustomPlayingCard(Suit.hearts, CardValue.jack),
      CustomPlayingCard(Suit.spades, CardValue.jack),
      CustomPlayingCard(Suit.spades, CardValue.jack),
    ];
    cards.shuffle();
    notifyListeners();
  }

  void selectCard(CustomPlayingCard card) {
    if (isProcessing || card.selected || card.matched) {
      return;
    }

    card.selected = true;
    notifyListeners();

    checkMatch();
  }

  void checkMatch() async {
    List<CustomPlayingCard> selectedCards = cards.where((card) => card.selected && !card.matched).toList();
    if (selectedCards.length == 2) {
      isProcessing = true;
      if (selectedCards[0].value == selectedCards[1].value && selectedCards[0].suit == selectedCards[1].suit) {
        for (var card in selectedCards) {
          card.matched = true;
        }
        players[currentPlayerIndex].nbrPoints += 1;
      } else {
        await Future.delayed(const Duration(seconds: 1));
        for (var card in selectedCards) {
          card.selected = false;
        }
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }
      isProcessing = false;
      notifyListeners();
    }
  }

  bool allCardsMatched() {
    return cards.every((card) => card.matched);
  }

  endGame() {
    players.sort((a, b) => b.nbrPoints.compareTo(a.nbrPoints));
  }
}