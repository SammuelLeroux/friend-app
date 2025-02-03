import 'package:playing_cards/playing_cards.dart';

class CustomPlayingCard extends PlayingCard {
  bool selected = false;
  bool matched = false;

  CustomPlayingCard(super.suit, super.value);
}
