import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:rafale/models/card99_model.dart';

class CardWidget extends StatelessWidget {
  final Card99Model card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.5,
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: PlayingCardView(card: card.card),
    );
  }
}
