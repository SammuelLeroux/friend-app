import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rafale/screens/home/newPassword_screen.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({super.key});
  @override
  _ForgotpasswordScreenState createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isCodeSent = false;
  String _code = '';
  // late = initialise la variable plus tard
  late http.Response responseCode;
  String idUser = "";

  void _forgotPassword() async{
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // check si le mail existe
    var url = Uri.parse('http://10.0.2.2:6000/api/mail');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email}),
    ); 
    if (response.statusCode == 200) {
      setState(() {
        _isCodeSent = true;
      });

      idUser = jsonDecode(response.body)['data']['id'];

      // envoie le mail de réinitialisation
      var url = Uri.parse('http://10.0.2.2:6000/api/reset');

      responseCode = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Un email de réinitialisation de mot de passe a été envoyé.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email non trouvé. Veuillez réessayer.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _verifyCode() async{
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (responseCode.statusCode == 200){
      var responseBody = jsonDecode(responseCode.body);
      var code = responseBody['data']['code'];
      var exp = responseBody['data']['exp'];
      var expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // check si le code est le bon et si la durée de validité n'est pas dépassée (5min)
      if (expDate.isAfter(DateTime.now())) {
        if (code == _code) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewPasswordScreen(idUser: idUser)),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Code incorrect. Veuillez réessayer.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La code a expiré.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _isCodeSent = false;
        });
      }
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
                        'Mot de passe oublié',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isCodeSent,
                    child: Padding(
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
                  ),
                  Visibility(
                    visible: _isCodeSent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Code',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: true,
                        onSaved: (value) => _code = value!, 
                        validator: (value) {
                          if (value!.isEmpty || value.length != 8) {
                            return 'Veuillez entrer un code valide.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _isCodeSent ? _verifyCode : _forgotPassword,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: const Text(
                            'Valider',
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