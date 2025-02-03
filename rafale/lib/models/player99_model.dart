import 'card99_model.dart';

class Player99 {
  final String name;
  List<Card99Model> hand;
  int penaltyCount = 0;

  Player99({required this.name, required this.hand});

  int get getPenaltyCount => penaltyCount;

  set setPenaltyCount(int nbr) => penaltyCount = nbr;
}
