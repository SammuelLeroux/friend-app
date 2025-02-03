import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafale/utils/app_colors.dart';
import 'aon_logic.dart';

class QodScreen extends StatefulWidget {
  const QodScreen({super.key});

  @override
  _QodScreenState createState() => _QodScreenState();
}

class _QodScreenState extends State<QodScreen>
    with SingleTickerProviderStateMixin {
  late QodLogic _qodLogic;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _qodLogic = QodLogic(this);
  }

  @override
  void dispose() {
    _qodLogic.dispose();
    super.dispose();
  }

  void askForNumber(bool singleDice) async {
    return showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text(singleDice
              ? 'Select a number between 1 and 6'
              : 'Select a number between 2 and 12'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: singleDice ? 3 : 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: singleDice ? 6 : 11,
              itemBuilder: (context, index) {
                int number = index + (singleDice ? 1 : 2);
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _qodLogic.rollDice(
                        number, singleDice, _scaffoldKey.currentContext!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Text(
                    '$number',
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _qodLogic,
      child: Consumer<QodLogic>(
        builder: (context, qodLogic, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.blueGrey[900],
            appBar: AppBar(
              title: const Text('Game Screen'),
              backgroundColor: AppColors.yellowOrange,
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Roll the Dice!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${qodLogic.diceOneValue + qodLogic.diceTwoValue}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(qodLogic.controller),
                          child: Icon(
                              qodLogic.getDiceIcon(qodLogic.diceOneValue),
                              size: 100,
                              color: AppColors.deepLemon),
                        ),
                        if (qodLogic.diceTwoValue != 0)
                          RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0)
                                .animate(qodLogic.controller),
                            child: Icon(
                                qodLogic.getDiceIcon(qodLogic.diceTwoValue),
                                size: 100,
                                color: AppColors.deepLemon),
                          ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              askForNumber(qodLogic.isDouble);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellowOrange,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: Text(
                              qodLogic.isDouble ? 'Double !' : 'Roll Dice',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        if (qodLogic.isDouble) const SizedBox(height: 8),
                        if (qodLogic.isDouble)
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                qodLogic.resetGame();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                              ),
                              child: const Text('Leave !',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
