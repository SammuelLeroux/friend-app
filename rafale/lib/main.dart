import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:rafale/screens/home/connexion_screen.dart';
import 'package:rafale/screens/home/splash_screen.dart';
import 'package:rafale/utils/audio_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioPlayerService(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    isUserLoggedIn('token').then((value) {
      isLoggedIn = value;
    });
    return MaterialApp(
      home: isLoggedIn ? const SplashScreen() : const ConnexionScreen(),
    );
  }
}

Future<bool> isUserLoggedIn(String key) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  String value = await storage.read(key: key) ?? 'No data found!';

  if (value != 'No data found!') {
    Map<String, dynamic> data = JwtDecoder.decode(value);
    //convert the exp date to a DateTime object (convert seconde to millisecond)
    final expDate = DateTime.fromMillisecondsSinceEpoch(data['exp'] * 1000);
    if (expDate.isAfter(DateTime.now())) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}
