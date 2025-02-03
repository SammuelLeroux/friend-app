import 'package:flutter/material.dart';
import 'package:rafale/screens/home/settings_screen.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:flutter/services.dart';

class MentionsLegalesScreen extends StatefulWidget {
  const MentionsLegalesScreen({super.key});

  @override
  MentionsLegalesState createState() => MentionsLegalesState();
}

class MentionsLegalesState extends State<MentionsLegalesScreen> {
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
                  const SizedBox(height: 25),  // Reduced height to move content up
                  Center(
                    child: Image.asset(
                      'lib/assets/logo.png',
                      height: 250,  // Reduced the height of the logo slightly
                    ),
                  ),
                  Flexible(  // Use Flexible instead of Expanded
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
                            Text(
                              'Propriété Intellectuelle :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "L'ensemble des éléments graphiques, sonores, textuels et logiciels de l'application sont protégés par les lois en vigueur sur la propriété intellectuelle et appartiennent exclusivement aux créateurs de l'application.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Conditions d\'Utilisation :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "L'application est destinée à un public majeur (18 ans et plus) et a pour but de proposer des mini-jeux à consommer dans le cadre privé et de manière responsable. L'éditeur décline toute responsabilité en cas de mauvaise utilisation de l'application ou de consommation excessive d'alcool.",
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
                              "Les créateurs de l'application ne pourront être tenus responsables des dommages directs ou indirects résultant de l'utilisation de l'application, notamment en cas de consommation excessive d'alcool. Il est rappelé que l'abus d'alcool est dangereux pour la santé, à consommer avec modération.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Données Personnelles :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "L'application ne collecte aucune donnée personnelle à l'insu de l'utilisateur. Les données éventuellement collectées (ex : scores, préférences de jeu) sont utilisées uniquement à des fins d'amélioration de l'expérience utilisateur et ne sont en aucun cas transmises à des tiers.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Droit Applicable :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellowOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Les présentes mentions légales sont régies par le droit français. En cas de litige, et après tentative de recherche d'une solution amiable, les tribunaux français seront seuls compétents.",
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