import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafale/utils/audio_service.dart';
import 'package:rafale/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<AudioPlayerService>(context, listen: false).changeMusic('beerpour.wav');
    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen(team: null,)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF626B), 
              Color(0xFFFFD935),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'lib/assets/RAFALE.gif', 
            width: 450, 
            height: 450, 
          ),
        ),
      ),
    );
  }
}


