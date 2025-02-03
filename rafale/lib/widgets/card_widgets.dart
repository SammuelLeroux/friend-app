import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:rafale/models/customplayingcard_model.dart';

class CardWidget extends StatelessWidget {
  final CustomPlayingCard card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: card.selected || card.matched ? Colors.white : const Color.fromARGB(255, 255, 0, 0),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Center(
          child: card.selected || card.matched 
              ? PlayingCardView(card: card)
              : const Text(''),
        ),
      ),
    );
  }
}
