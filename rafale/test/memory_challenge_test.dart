import 'package:flutter_test/flutter_test.dart';
import 'package:rafale/models/customplayingcard_model.dart';
import 'package:rafale/models/player.dart';
import 'package:rafale/providers/memory_logic.dart';
import 'package:playing_cards/playing_cards.dart';


void main() {
  group('Memory Game Logic Tests', () {
    late MemoryLogic game;
    late List<Player> players;

    setUp(() {
      players = [
        Player(name: 'Player 1', nbrPoints: 0),
        Player(name: 'Player 2', nbrPoints: 0),
      ];
      game = MemoryLogic(players: players);
      game.initializeCards();
    });

    test('Initial card state', () {
      expect(game.cards.length, 16);
      expect(game.cards.every((card) => !card.selected && !card.matched), isTrue);
    });

    test('Select card', () {
      CustomPlayingCard card = game.cards[0];
      game.selectCard(card);
      expect(card.selected, isTrue);
    });

    test('Check match', () async {
      CustomPlayingCard firstCard = game.cards.firstWhere((card) => card.suit == Suit.hearts && card.value == CardValue.king);
      CustomPlayingCard secondCard = game.cards.lastWhere((card) => card.suit == Suit.hearts && card.value == CardValue.king);

      game.selectCard(firstCard);
      game.selectCard(secondCard);

      await Future.delayed(const Duration(seconds: 1));

      expect(firstCard.matched, isTrue);
      expect(secondCard.matched, isTrue);
      expect(players[0].nbrPoints, 1);
    });

    test('Check mismatch', () async {
      CustomPlayingCard firstCard = game.cards.firstWhere((card) => card.suit == Suit.hearts && card.value == CardValue.king);
      CustomPlayingCard secondCard = game.cards.firstWhere((card) => card.suit == Suit.spades && card.value == CardValue.queen);

      game.selectCard(firstCard);
      game.selectCard(secondCard);

      await Future.delayed(const Duration(seconds: 1));

      expect(firstCard.selected, isFalse);
      expect(secondCard.selected, isFalse);
      expect(players[0].nbrPoints, 0);
      expect(game.currentPlayerIndex, 1);
    });

    test('Game end check', () async {
      for (int i = 0; i < game.cards.length; i += 2) {
        game.cards[i].matched = true;
        game.cards[i + 1].matched = true;
      }

      expect(game.endGame(), isTrue);
    });

    test('Player rotation', () async {
      CustomPlayingCard firstCard = game.cards.firstWhere((card) => card.suit == Suit.hearts && card.value == CardValue.king);
      CustomPlayingCard secondCard = game.cards.firstWhere((card) => card.suit == Suit.spades && card.value == CardValue.queen);

      game.selectCard(firstCard);
      game.selectCard(secondCard);

      await Future.delayed(const Duration(seconds: 1));

      expect(game.currentPlayerIndex, 1);

      game.selectCard(firstCard);
      game.selectCard(secondCard);

      await Future.delayed(const Duration(seconds: 1));

      expect(game.currentPlayerIndex, 0);
    });
  });
}
