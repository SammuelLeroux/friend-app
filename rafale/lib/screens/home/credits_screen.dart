import 'package:flutter/material.dart';
import 'package:rafale/screens/home/settings_screen.dart';
import 'package:rafale/utils/app_colors.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  CreditsState createState() => CreditsState();
}

class CreditsState extends State<CreditsScreen> {
  void onPressedButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.terraCotta,
        elevation: 0,
        title: const Text(
          'Crédits',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Center(
                    child: Image.asset(
                      'lib/assets/logo.png',
                      height: 250,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,  // Changed to center the text
                      children: [
                        Text(
                          'Equipe de développement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.yellowOrange,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Gabriel\n'
                          '• Jérôme\n'
                          '• Léo\n'
                          '• Matthieu\n'
                          '• Sammuel\n'
                          '• Tristan\n',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onPressedButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Retour',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}