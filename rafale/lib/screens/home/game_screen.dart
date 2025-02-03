import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rafale/models/playerRoulette_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rafale/screens/game/421/421GameRulesScreen.dart';
import 'package:rafale/screens/game/99/99RulesScreen.dart';
import 'package:rafale/screens/game/BlindTest/rules_blind_test_screen.dart';
import 'package:rafale/screens/game/MemoryChallenge/memory_rules_screen.dart';
import 'package:rafale/screens/game/RussianRoulette/RouletteRulesScreen.dart';
import 'package:rafale/screens/game/TruthOrDare/rulesTruthOrDare.dart';
import 'package:rafale/screens/game/bus/rules_bus_screen.dart';
import 'package:rafale/screens/game/AllOrNothing/aon_screen.dart';
import 'package:rafale/screens/game/course/course_rule_screen.dart';
import 'package:rafale/screens/game/purple/purple_screen.dart';
import '../../utils/app_colors.dart';
import '../../models/player.dart';
import 'package:http/http.dart' as http;

class RafalePage extends StatefulWidget {
  final List<Player> players; 

  const RafalePage({super.key, required this.players});

  @override
  _RafalePageState createState() => _RafalePageState();
}

class _RafalePageState extends State<RafalePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Map<String, String> userInfo = {
    "id": "",
    "username": "",
    "email": "",
    "premium": "",
    "phone": ""
  };
  final List<String> games = [
    'Jeu aléatoire',
    'Blind Test',
    'Purple',
    'Action ou Vérité',
    'Memory Challenge',
    '99',
    'Bus',
    'All Or Nothing',
    '421',
    'Roulette Russe',
    'Course de Kro'
  ];
  final List<String> premiumGames = [
    'Coming soon'
  ];
  bool isPremium = false;
  int _currentPage = 0;
  int _selectedIndex = 0;

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
          isPremium = userInfo['premium'] == 'true';
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Request failed with error: $e.');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfoByToken();
  }

    void _navigateToGame(int index) {
    switch (index) {
      case 0:
        randomGame();
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RulesBlindTestScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PurpleGame()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RulesTruthOrDareScreen(players: widget.players)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MemoryRulesScreen(players: widget.players)),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Game99RulesScreen(
              playerNames: widget.players.map((player) => player.name).toList(),
            ),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bus()),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Rules421Screen(
              playerNames: widget.players.map((player) => player.name).toList(),
            ),
          ),
        );
        break;
      case 8:
        final random = Random();
        final List<PlayerRoulette> selectedPlayers = List<PlayerRoulette>.from(
          widget.players.map((player) => PlayerRoulette(name: player.name))
        )..shuffle(random);
     
        final playersForRoulette = selectedPlayers.sublist(0, 2);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RouletteRulesScreen(players: playersForRoulette)),
        );
        break;
      case 9:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RulesCourseScreen(
                    playerNames:
                        widget.players.map((player) => player.name).toList(),
                  )),
        );
        break;
      case 10:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QodScreen()),
        );
        break;
      default:
        print('Invalid game index');
    }
  }

  void randomGame() {
    final random = Random();
    final index = random.nextInt(games.length);
    _navigateToGame(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Image.asset(
              'lib/assets/logo.png',
              height: 250,
            ),
          ),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 230, 43, 43),
            labelColor: Color.fromARGB(255, 230, 43, 43),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Jeux'),
              Tab(text: 'Quizz'),
              Tab(text: 'Enigme'),
            ],
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: TabBarView(
          children: [
            _buildGameList(screenWidth),
            const Center(child: Text('Quizz')),
            const Center(child: Text('Enigme')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoris',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 230, 43, 43),
          selectedLabelStyle: const TextStyle(color: Colors.transparent),
          unselectedLabelStyle: const TextStyle(color: Colors.transparent),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildGameList(double screenWidth) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.08,
            child: Image.asset(
              'lib/assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 250),
                SizedBox(
                  height: 455,
                  child: PageView.builder(
                    itemCount: games.length,
                    controller: PageController(viewportFraction: 0.85),
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      double scale = index == _currentPage ? 1.0 : 0.8;
                      double margin = index == _currentPage ? 10 : 10;
                      return GestureDetector(
                        onTap: () {
                          _navigateToGame(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: margin),
                          transform: Matrix4.identity()
                            ..translate((1 - scale) * screenWidth * 0.1)
                            ..scale(scale),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: SizedBox(
                              width: 350,
                              height: 450,
                              child: Center(
                                child: _buildGameCardContent(index),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameCardContent(int index) {
    switch (index) {
      case 0:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/magienoir.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      case 1:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/blindtest.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      case 2:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/newpurple.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      case 3:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/le99.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      case 4:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/le21.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      case 5:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'lib/assets/pmu.png',
            fit: BoxFit.cover,
            width: 350,
            height: 450,
          ),
        );
      default:
        return Text(
          games[index],
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
            color: AppColors.persianRed,
          ),
        );
    }
  }
}
