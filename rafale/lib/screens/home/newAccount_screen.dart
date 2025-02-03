import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import 'package:rafale/screens/home/connexion_screen.dart';

class NewaccountScreen extends StatefulWidget {
  const NewaccountScreen({super.key});
  @override
  _NewaccountScreen createState() => _NewaccountScreen();
}

class _NewaccountScreen extends State<NewaccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _phone = '';
  String _email = '';
  String _password1 = '';
  String _password2 = '';

  Future<void> _newAccount() async{
    var url = Uri.parse('http://10.0.2.2:6000/api/user');
    // Sauvegarde les valeurs dans les variables _email et _password
    _formKey.currentState!.save();
    // Vérifie que les valeurs sont valides
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _username,
        'email': _email,
        'password': _password1,
        'prenium': false,
        'phone': _phone,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnexionScreen()));
    }
    else if(response.statusCode == 409){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ce compte existe déjà.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erreur lors de la création du compte.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

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
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Nouveau compte',
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _username = value!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer un nom d\'utilisateur.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: false,
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Téléphone',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: false,
                      onSaved: (value) => _phone = value!,
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10 || value.contains(RegExp(r'[a-zA-Z]'))) {
                          return 'Veuillez entrer un numéro valide.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: true,
                      onSaved: (value) => _password1 = value!,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Veuillez entrer un mot de passe valide.';
                        }
                        else if (value != _password2) {
                          return 'Les mots de passe ne correspondent pas.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmer mot de passe',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      obscureText: true,
                      onSaved: (value) => _password2 = value!,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Veuillez entrer un mot de passe valide.';
                        } else if (value != _password1) {
                          return 'Les mots de passe ne correspondent pas.';
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
