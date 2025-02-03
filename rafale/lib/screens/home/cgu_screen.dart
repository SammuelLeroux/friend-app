import 'package:flutter/material.dart';
import 'package:rafale/screens/home/settings_screen.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:flutter/services.dart';

class CguScreen extends StatefulWidget {
  const CguScreen({super.key});

  @override
  CguState createState() => CguState();
}

class CguState extends State<CguScreen> {
  void onPressedButton() {
    SystemSound.play(SystemSoundType.click);
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
          'Mentions Légales',
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
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Introduction :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Cette application de mini-jeux d'alcool est destinée à un public majeur. En utilisant cette application, vous acceptez de jouer de manière responsable et de respecter la législation en vigueur dans votre pays.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Responsabilité :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Les développeurs de cette application ne peuvent être tenus responsables des conséquences liées à une consommation excessive d'alcool. Il est de votre responsabilité de jouer de manière sûre et consciente.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Conditions d\'utilisation :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "L'utilisation de cette application est réservée aux personnes majeures. Vous devez avoir au moins 18 ans pour jouer. En utilisant cette application, vous certifiez que vous respectez cette condition.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Modifications :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Nous nous réservons le droit de modifier ces conditions générales d'utilisation à tout moment. Veuillez consulter cette page régulièrement pour vous tenir informé des mises à jour.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        color: Colors.white,
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
