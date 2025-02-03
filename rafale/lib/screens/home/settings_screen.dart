import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafale/utils/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafale/utils/app_colors.dart';
import 'cgu_screen.dart';
import 'credits_screen.dart';
import 'mentions_legales_screen.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String clientId = dotenv.env['PAYPAL_CLIENT_ID'] ?? '';
  final String clientSecret = dotenv.env['PAYPAL_CLIENT_SECRET'] ?? '';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Map<String, String> userInfo = {
    "id": "",
    "username": "",
    "email": "",
    "premium": "",
    "phone": ""
  };
  double _volume = 50;
  bool _notificationsEnabled = true;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    getUserInfoByToken();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _volume = prefs.getDouble('volume') ?? 50.0;
    });
  }

  Future<void> getUserInfoByToken() async {
    String? token = await storage.read(key: 'token');
    if (token == null) return;

    Map<String, dynamic> payload = Jwt.parseJwt(token);
    String userId = payload['userId'];
    var url = 'http://10.0.2.2:6000/api/user/$userId';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['data'];
        setState(() {
          userInfo = {
            "id": data['_id'],
            "username": data['username'],
            "email": data['email'],
            "premium": data['prenium'].toString(),
            "phone": data['phone']
          };
        });
      } else {
        log('Failed to load user info');
      }
    } catch (e) {
      log('Failed to load user info');
    }
  }

  Future<void> _setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _setVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
    setState(() {
      _volume = value;
    });

    final playerService = Provider.of<AudioPlayerService>(context, listen: false);
    playerService.setVolume(value / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Settings'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        child: Icon(Icons.person, size: 45),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () {
                          // Add your edit profile logic here
                        },
                        child: const Text(
                          'Profil',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          title: Text(
                            'Options',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SwitchListTile(
                          title: const Text(
                            'Notifications',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          secondary: Icon(
                            _notificationsEnabled
                                ? Icons.notifications
                                : Icons.notifications_off,
                          ),
                          value: _notificationsEnabled,
                          onChanged: (bool value) {
                            _setNotificationsEnabled(value);
                          },
                        ),
                        const SizedBox(height: 35),
                        const ListTile(
                          title: Text(
                            'Volume',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Slider(
                          value: _volume,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: _volume.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _setVolume(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35), // Adjust the space as needed
                  if (userInfo['premium'] == 'false')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PaypalCheckoutView(
                            sandboxMode: true,
                            clientId: clientId,
                            secretKey: clientSecret,
                            transactions: const [
                              {
                                "amount": {
                                  "total": '9.99',
                                  "currency": "EUR",
                                  "details": {
                                    "subtotal": '9.99',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "Rafale PREMIUM",
                                      "quantity": 1,
                                      "price": '9.99',
                                      "currency": "EUR"
                                    },
                                  ],
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              try {
                                var userId = userInfo[
                                    'id']; // Assurez-vous que userInfo contient 'id'
                                var url =
                                    'http://10.0.2.2:6000/api/user/$userId';

                                var headers = {
                                  'Content-Type':
                                      'application/json', // Spécifie le type de contenu
                                };

                                var body = jsonEncode({'prenium': true});

                                var response = await http.put(
                                  Uri.parse(url),
                                  headers: headers,
                                  body: body,
                                );

                                if (response.statusCode == 200) {
                                  // Si le serveur retourne une réponse OK, traiter la réponse
                                  log("User premium status updated successfully: $params");
                                } else {
                                  // Gérer les réponses d'erreur du serveur
                                  log("Failed to update user premium status: ${response.body}");
                                }

                                userInfo['premium'] = 'true';

                                Navigator.pop(context);
                              } catch (e) {
                                log("Error updating user info: $e");
                              }
                            },
                            onError: (error) {
                              log("onError: $error");
                              Navigator.pop(context);
                            },
                            onCancel: () {
                              log("onCancel");
                              Navigator.pop(context);
                            },
                          ),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color(0xFF003087), // Couleur du texte
                        elevation: 4, // L'élévation du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Arrondir les coins du bouton
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12), // Padding interne
                      ),
                      icon: const Icon(
                        Icons
                            .payment, // Icône représentative, envisagez d'utiliser une icône PayPal personnalisée si disponible
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Pay with PayPal',
                        style: TextStyle(
                          fontSize: 16, // Taille de police
                          fontWeight: FontWeight.bold, // Gras
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.description, color: AppColors.terraCotta),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CguScreen()),
                );
              },
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.scaleBalanced,
                  color: AppColors.terraCotta),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MentionsLegalesScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.group, color: AppColors.terraCotta),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreditsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
