import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rafale/screens/home/forgotPassword_screen.dart';
import 'package:rafale/screens/home/newAccount_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rafale/screens/home/splash_screen.dart';

import '../../utils/app_colors.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});
  @override
  _ConnexionScreenState createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _forgotPassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ForgotpasswordScreen()),
    );
  }

  Future<void> _login() async {
    // 10.0.2.2 équivalent de localhost pour l'émulateur Android
    var url = Uri.parse('http://10.0.2.2:6000/api/login');
    // Sauvegarde les valeurs dans les variables _email et _password
    _formKey.currentState!.save();
    // Vérifie que les valeurs sont valides
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email, 'password': _password}),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var token = responseBody['data']['data'];
      const storage = FlutterSecureStorage();
      // stock le token fournit par le back dans le storage sécurisé
      await storage.write(key: 'token', value: token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mauvais email ou mot de passe. Veuillez réessayer.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _newAccount() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewaccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text(
                        'Connexion',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value!,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Veuillez entrer un email valide.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: true,
                      onSaved: (value) => _password = value!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer un mot de passe valide.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _newAccount,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: const Text(
                            'Créer un compte',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _forgotPassword,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: const Text(
                              'Mot de passe oublié',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
