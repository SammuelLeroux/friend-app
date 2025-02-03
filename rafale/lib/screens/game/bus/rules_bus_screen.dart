import 'package:flutter/material.dart';
import 'package:rafale/screens/game/bus/destination_bus_screen.dart';
import 'package:rafale/utils/app_colors.dart';

class Bus extends StatelessWidget {
  const Bus({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus - Règles'),
      ),
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Le Bus est un jeu de cartes qui consiste à atteindre la déstination de vos rêves en prenant le bus. Le but est de déviné si la carte tirée est plus grande ou plus petite que la carte précédente. Si vous avez raison, vous avancez d\'une case, sinon vous revenez au dernier checkpoint et buvez le nombre de gorgé qui correspond au nombre de case que vous reculez. Bonne chance !',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20), 
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  DestinationBusScreen()),
                    );
                  },
                  child: const Text('Suivant'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
