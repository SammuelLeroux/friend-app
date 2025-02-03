import 'dart:math';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:rafale/screens/game/bus/bus_win_screen.dart';
import 'package:rafale/utils/app_colors.dart';

class GameBusScreen extends StatefulWidget {
  final int? nbCarte;
  final int? nbCheckpoint;

  const GameBusScreen({super.key, required this.nbCarte, required this.nbCheckpoint});

  @override
  _GameBusScreenState createState() => _GameBusScreenState();
}

class _GameBusScreenState extends State<GameBusScreen> {
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<PlayingCard> allCard = [];
  // index du dernier checkpoint passé
  int lastCheckpointPassed = 0;
  int returnCard = -10;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= (widget.nbCarte! + widget.nbCheckpoint!); i++) {
      allCard.add(getRandomCard());
    }
  }

  setLastCheckpointPassed(int index){
    switch (index) {
      case 5:
        lastCheckpointPassed = index;
        break;
      case 11:
        lastCheckpointPassed = index;
        break;
      case 17:
        lastCheckpointPassed = index;
        break;
    }
  }

  inCrementeIndex(String color){
    if (selectedIndex != (widget.nbCarte! + widget.nbCheckpoint!)) {
      if (selectedIndex == lastCheckpointPassed && selectedIndex != 0){
        setState(() {
          selectedIndex = (selectedIndex + 1);
          setLastCheckpointPassed(selectedIndex);
          if (_scrollController.hasClients) {
            final position = (selectedIndex * 100).toDouble();
            _scrollController.animateTo(
              position,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Les autres joueurs boivent une gorgée !',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
      else if (allCard[selectedIndex].suit == Suit.hearts && color == 'rouge' || allCard[selectedIndex].suit == Suit.diamonds && color == 'rouge') {
        setState(() {
          returnCard = selectedIndex;
          selectedIndex = (selectedIndex + 1);
          Future.delayed(const Duration(milliseconds: 300), (){
            setLastCheckpointPassed(selectedIndex);
            if (_scrollController.hasClients) {
              final position = (selectedIndex * 100).toDouble();
              _scrollController.animateTo(
                position,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        });
      } else if (allCard[selectedIndex].suit == Suit.clubs && color == 'noir' || allCard[selectedIndex].suit == Suit.spades && color == "noir"){
        setState(() {
          returnCard = selectedIndex;
          selectedIndex = (selectedIndex + 1);
          Future.delayed(const Duration(milliseconds: 300), (){
            setLastCheckpointPassed(selectedIndex);
            if (_scrollController.hasClients) {
              final position = (selectedIndex * 100).toDouble();
              _scrollController.animateTo(
                position,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        });
      }
      else{
        resetCard();
      }
    }else{
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BusWin()),
      );
    }
  }

  //logique pour la lose
  resetCard(){
    if (lastCheckpointPassed != 0) {
      selectedIndex = lastCheckpointPassed + 1;
    }
    else{
      selectedIndex = 0;
    }
    setState(() {
      allCard = [];
      for (var i = 0; i <= (widget.nbCarte! + widget.nbCheckpoint!); i++) {
        allCard.add(getRandomCard());
      }
      returnCard = -10;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Tu as perdu, tu dois boire une gorgée !',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
    if (_scrollController.hasClients) {
      final position = (selectedIndex * 100).toDouble();
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  PlayingCard getRandomCard(){
      List<Suit> allCardSuit = [
        Suit.clubs,
        Suit.diamonds,
        Suit.hearts,
        Suit.spades,
      ];

      List<CardValue> allCardValues = [
        CardValue.ace,
        CardValue.two,
        CardValue.three,
        CardValue.four,
        CardValue.five,
        CardValue.six,
        CardValue.seven,
        CardValue.eight,
        CardValue.nine,
        CardValue.ten,
        CardValue.jack,
        CardValue.queen,
        CardValue.king,
      ];

      Random random = Random();

      Suit randomSuit = allCardSuit[random.nextInt(allCardSuit.length)];
      CardValue randomValue = allCardValues[random.nextInt(allCardValues.length)];
      return PlayingCard(randomSuit, randomValue);
    }

  bool getShowBack(int index){
    if(index == returnCard){
      return false;
    }
    else if(index == 5 || index == 11 || index == 17){
      return false;
    }
    else  if (widget.nbCheckpoint == 0) {
      return true;
    }
    else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Bus'),
      ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: (widget.nbCarte! + widget.nbCheckpoint!),
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: PlayingCardView(
                            card: allCard[index],
                            showBack: getShowBack(index),
                          ),
                        ),
                        if (index == selectedIndex) 
                          const Icon(Icons.arrow_upward, color: Colors.white,size: 30.0,), 
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        inCrementeIndex('rouge');
                      },
                      child: const Text('Rouge'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        inCrementeIndex('noir');
                      },
                      child: const Text('Noir'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}