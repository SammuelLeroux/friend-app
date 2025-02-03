import 'package:flutter/material.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:rafale/models/player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Dare {
  final String sentence;
  final String idUser;
  final String type;
  final String category;
  final int drink;

  Dare({required this.sentence, required this.idUser, required this.type, required this.category, required this.drink});

  factory Dare.fromJson(Map<String, dynamic> json) {
    return Dare(
      sentence: json['sentence'],
      idUser: json['id_user'],
      type: json['type'],
      category: json['category'],
      drink: json['drink'],
    );
  }
}

class Truth {
  final String sentence;
  final String idUser;
  final String type;
  final String category;
  final int drink;

  Truth({required this.sentence, required this.idUser, required this.type, required this.category, required this.drink});

  factory Truth.fromJson(Map<String, dynamic> json) {
    return Truth(
      sentence: json['sentence'],
      idUser: json['id_user'],
      type: json['type'],
      category: json['category'],
      drink: json['drink'],
    );
  }
}

class TruthOrDareScreen extends StatefulWidget {
  const TruthOrDareScreen({super.key, required this.players});

  final List<Player> players;

  @override
  _TruthOrDareScreenState createState() => _TruthOrDareScreenState();
}

class _TruthOrDareScreenState extends State<TruthOrDareScreen> {
  List<Dare> dares = [];
  int currentDareIndex = 0;
  List<Truth> truths = [];
  int currentTruthIndex = 0;
  final Random random = Random();
  Player? currentPlayer;
  dynamic currentAction;
  bool isLoading = true;
  bool isAction = false;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final TextEditingController sentenceController = TextEditingController();
  final TextEditingController drinkController = TextEditingController();
  String selectedValue = 'Dare'; // Default value

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void pressedPlus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter votre propre action ou vérité'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedValue,
                items: const [
                  DropdownMenuItem(value: 'Dare', child: Text('Action')),
                  DropdownMenuItem(value: 'Truth', child: Text('Vérité')),
                ],
                onChanged: (String? newValueSelected) {
                  if (newValueSelected != null) {
                    setState(() {
                      selectedValue = newValueSelected;
                    });
                  }
                },
              ),
              TextField(
                controller: sentenceController,
                decoration: const InputDecoration(
                  hintText: 'Phrase',
                ),
              ),
              TextField(
                controller: drinkController,
                decoration: const InputDecoration(
                  hintText: 'Nombre(s) de gorgée(s)',
                ),
                keyboardType: TextInputType.number,
              ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              child: const Text('Créer'),
              onPressed: () {
                createAction(
                  sentenceController.text,
                  selectedValue,
                  int.parse(drinkController.text),
                  'test',
                );
                Navigator.of(context).pop();
              },
            ),
        ],
      );
    },
  );
}

Future<void> createAction(String sentence, String type, int drink, String idUser) async {
  final url = Uri.parse('http://10.0.2.2:6000/api/action');
  String userId =  await getUserId();
  debugPrint('userId: $userId');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'type': type,
      'sentence': sentence,
      'id_user': userId,
      'category': 'Simple',
      'drink': drink,
    }),
  );

  if (response.statusCode == 201) {
    print('Action créée avec succès');
  } else {
    print('Échec de la création de l\'action');
  }
}

  Future<void> fetchData() async {
    try {
      await fetchDare();
      await fetchTruth();
      selectRandomPlayer();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> getUserId() async {
    String? token = await storage.read(key: 'token');

    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String userId = payload['userId'];

    return userId;
  }

  void selectRandomPlayer() {
    setState(() {
      currentPlayer = widget.players[random.nextInt(widget.players.length)];
    });
  }

  void selectRandomAction(type) {
    setState(() {
      if (type == 'Action') {
        currentAction = dares.isNotEmpty ? dares[random.nextInt(dares.length)] : null;
      } else {
        currentAction = truths.isNotEmpty ? truths[random.nextInt(truths.length)] : null;
      }
    });
  }

  void newRound(){
    setState(() {
      isAction = false;
      selectRandomPlayer();
    });
  }

  void onTapAction(String type) {
      selectRandomAction(type);
      setState(() {
        isAction = true;
      });
  }

  Future<void> fetchTruth() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:6000/api/action/truth'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('data') && responseJson['data'].containsKey('data')) {
        List<dynamic> truthsJson = responseJson['data']['data'];
        List<Truth> truths = truthsJson.map((truthJson) => Truth.fromJson(truthJson)).toList();
        setState(() {
          this.truths = truths;
          currentTruthIndex = random.nextInt(truths.length);
        });
      } else {
        throw Exception('Key "data" not found in the response');
      }
    } else {
      throw Exception('Failed to load truths');
    }
  }

  Future<void> fetchDare() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:6000/api/action/dare'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('data') && responseJson['data'].containsKey('data')) {
        List<dynamic> daresJson = responseJson['data']['data'];
        List<Dare> dares = daresJson.map((dareJson) => Dare.fromJson(dareJson)).toList();
        setState(() {
          this.dares = dares;
          currentDareIndex = random.nextInt(dares.length);
        });
      } else {
        throw Exception('Key "data" not found in the response');
      }
    } else {
      throw Exception('Failed to load dares');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action ou vérité'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/logo.png',
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: pressedPlus,
                        child: const FaIcon(
                          FontAwesomeIcons.plus,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (isAction == false)
                    Center(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: AppColors.green,
                        child: SizedBox(
                          width: 225,
                          height: 310,
                          child: Center(
                            child: Text(
                              '${currentPlayer?.name} à toi de choisir',
                              style: const TextStyle(color: Colors.white, fontSize: 35),
                              textAlign: TextAlign.center, 
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                  Center(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      color: currentAction?.type == 'Truth' ? AppColors.green : AppColors.terraCotta,
                        child: SizedBox(
                          width: 225,
                          height: 310,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  currentPlayer?.name ?? 'No player',
                                  style: const TextStyle(color: Colors.white, fontSize: 35),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                indent: 15,
                                endIndent: 15,
                              ),
                              const Spacer(),
                              Center(
                                child: Text(
                                  currentAction?.sentence ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (currentAction != null)
                                    Text(
                                      currentAction.drink.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  const Icon(Icons.local_bar_sharp, color: Colors.black),
                                ],
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  currentAction?.type ?? '',
                                  style: const TextStyle(color: Color.fromRGBO(230, 225, 225, 0.3), fontSize: 60, fontFamily: 'Raleway'),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (isAction == true)
                          Card(
                            clipBehavior: Clip.hardEdge,
                            color: AppColors.green,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                newRound();
                              },
                              child: const SizedBox(
                                width: 100,
                                height: 30,
                                child: Center(child: Text('Suivant')),
                              ),
                            ),
                          )
                        else
                          Card(
                            clipBehavior: Clip.hardEdge,
                            color: AppColors.green,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                onTapAction('Vérité');
                              },
                              child: const SizedBox(
                                width: 100,
                                height: 30,
                                child: Center(child: Text('Vérité')),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          if (isAction == false)
                            Card(
                              clipBehavior: Clip.hardEdge,
                              color: AppColors.terraCotta,
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  onTapAction('Action');
                                },
                                child: const SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Center(child: Text('Action')),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}