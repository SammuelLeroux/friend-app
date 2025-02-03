import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafale/models/player.dart';
import 'package:rafale/providers/memory_logic.dart';
import 'package:rafale/widgets/card_widgets.dart';
import 'package:rafale/utils/app_colors.dart';

class MemoryGameScreen extends StatelessWidget {
  final List<Player> players;

  const MemoryGameScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoryLogic(players: players),
      child: Scaffold(
        appBar: AppBar(title: const Text('Memory Game')),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.lightSalmonPink,
                AppColors.deepLemon,
              ],
            ),
          ),
          child: Column(
            children: [
              Consumer<MemoryLogic>(
                builder: (context, game, _) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tour de ${game.players[game.currentPlayerIndex].name}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: AppColors.persianRed,
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Consumer<MemoryLogic>(
                  builder: (context, game, _) {
                    if (game.allCardsMatched()) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showEndGameDialog(context, game);
                      });
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                      itemCount: game.cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            game.selectCard(game.cards[index]);
                          },
                          child: CardWidget(card: game.cards[index]),
                        );
                      },
                    );
                  },
                ),
              ),
              Consumer<MemoryLogic>(
                builder: (context, game, _) {
                  return Column(
                    children: game.players.map((player) {
                      return Text('${player.name}: ${player.nbrPoints} points');
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEndGameDialog(BuildContext context, MemoryLogic game) {
    // Sort players by their points in descending order
    List<Player> sortedPlayers = List.from(game.players)
      ..sort((a, b) => b.nbrPoints.compareTo(a.nbrPoints));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fin du jeu'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Classement final:'),
                ...sortedPlayers
                    .map((player) =>
                        Text('${player.name}: ${player.nbrPoints} points'))
                    ,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Quitter'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); 
                Navigator.of(context).pop();
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
}
