import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafale/utils/audio_service.dart';
import 'package:rafale/screens/home/game_screen.dart';
import 'package:rafale/screens/home/settings_screen.dart';
import '../../utils/app_colors.dart';
import '../../models/player.dart'; // Import the Player class
import 'import_team_screen.dart';

class HomeScreen extends StatefulWidget {
  final team;

  const HomeScreen({super.key, required this.team});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController playerController = TextEditingController();
  final List<String> players = []; 
  
  void _addPlayer() {
    final String playerName = playerController.text;
    if (playerName.isNotEmpty && !players.contains(playerName)) {
      setState(() {
        players.add(playerName);
      });
      playerController.clear();
    }
  }

  void _removePlayer(int index) {
    setState(() {
      players.removeAt(index);
    });
  }

  void _navigateToGameScreen() {
    // Convert the list of player names to a list of Player objects
    List<Player> playerObjects = players.map((name) => Player(name: name, nbrPoints: 0)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RafalePage(players: playerObjects)),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _navigateToImportTeamScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImportTeamScreen()),
    );
  }

  void _importTeam() {
    if (widget.team != null && players.isEmpty) {
      widget.team.players.map((player) => players.add(player)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AudioPlayerService>(context, listen: false).stop();
    _importTeam();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
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
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 0.0),
                  child: Image(
                    image: AssetImage('lib/assets/logo.png'),
                    height: 260.0, 
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    controller: playerController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Entrez le nom du joueur',
                      prefixIcon: const Icon(Icons.person, color: AppColors.persianRed),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                        
                      ),
                      contentPadding: const EdgeInsets.all(20.0),
                    ),
                    style: const TextStyle(color: AppColors.persianRed),
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToImportTeamScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.persianRed,
                  ),
                  child: const Text(
                    'Importer des joueurs',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            leading: const Icon(Icons.person, color: AppColors.persianRed),
                            title: Text(
                              players[index],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.persianRed),
                              onPressed: () => _removePlayer(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToGameScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.persianRed,
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'settings_fab',
                  onPressed: _navigateToSettings,
                  backgroundColor: AppColors.persianRed,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'add_player_fab',
                  onPressed: _addPlayer,
                  backgroundColor: AppColors.persianRed,
                  foregroundColor: Colors.white, 
                  child: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
