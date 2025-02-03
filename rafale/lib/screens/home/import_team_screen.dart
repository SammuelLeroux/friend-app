import 'package:flutter/material.dart';
import 'package:rafale/screens/home/home_screen.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Team {
  String id;
  String name;
  List<String> players;

  Team({required this.id, required this.name, required this.players});
}

class ImportTeamScreen extends StatefulWidget {
  const ImportTeamScreen({super.key});

  @override
  _ImportTeamScreenState createState() => _ImportTeamScreenState();
}

class _ImportTeamScreenState extends State<ImportTeamScreen> {
  List<Team> teams = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _importTeam();
  }

  Future<String> _getUserId() async {
    String? token = await storage.read(key: 'token');

    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String userId = payload['userId'];

    return userId;
  }

  Future<void> _importTeam() async {
    String userId = await _getUserId();

    var url = Uri.parse("http://10.0.2.2:6000/api/team/$userId");

    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];

      List<Team> importedTeams = data['data'].map<Team>((team) {
        return Team(
          id: team['_id'],
          name: team['teamName'],
          players: List<String>.from(team['names'] ?? []),
        );
      }).toList();

      setState(() {
        teams = importedTeams;
      });
    }
  }

  Future<void> _addTeam(String teamName) async {
    var url = Uri.parse('http://10.0.2.2:6000/api/team');
    String userId = await _getUserId();
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "IdUser": userId,
        "TeamName": teamName,
        "Names": [],
      }),
    );

    var responseBody = jsonDecode(response.body);
    var insertedId = responseBody['data']['data']['InsertedID'];

    setState(() {
      teams.add(Team(id: insertedId, name: teamName, players: []));
    });
  }

  Future<void> _editTeam(int index, String newTeamName) async {
    var teamId = teams[index].id.toString();
    var url = Uri.parse("http://10.0.2.2:6000/api/team/$teamId");
    String userId = await _getUserId();

    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "IdUser": userId,
        "TeamName": newTeamName,
        "Names": teams[index].players,
      }),
    );

    setState(() {
      teams[index].name = newTeamName;
    });
  }

  Future<void> _deleteTeam(int index) async {
    var teamId = teams[index].id.toString();
    var url = Uri.parse("http://10.0.2.2:6000/api/team/$teamId");

    var response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      teams.removeAt(index);
    });
  }

  Future<void> _addPlayer(int teamIndex, String playerName) async {
    var teamId = teams[teamIndex].id;
    developer.log(teamId.toString());
    var url = Uri.parse("http://10.0.2.2:6000/api/team/$teamId/player");
    String userId = await _getUserId();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "IdUser": userId,
        "name": playerName,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        teams[teamIndex].players.add(playerName);
      });
    }
  }

  Future<void> _editPlayer(int teamIndex, int playerIndex, String newPlayerName) async {
    var teamId = teams[teamIndex].id;
    var playerName = teams[teamIndex].players[playerIndex];
    var url = Uri.parse("http://10.0.2.2:6000/api/team/$teamId/player/$playerName");

    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": newPlayerName,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        teams[teamIndex].players[playerIndex] = newPlayerName;
      });
    }
  }

  Future<void> _deletePlayer(int teamIndex, int playerIndex) async {
    var teamId = teams[teamIndex].id.toString();
    var playerName = teams[teamIndex].players[playerIndex];
    var url = Uri.parse("http://10.0.2.2:6000/api/team/$teamId/player/$playerName");

    var response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        teams[teamIndex].players.removeAt(playerIndex);
      });
    }
  }

  void _showTeamDialog({int? index}) {
    final TextEditingController controller = TextEditingController(
      text: index != null ? teams[index].name : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Créer une équipe' : 'Modifier l\'équipe'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nom de l\'équipe'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  if (index == null) {
                    _addTeam(controller.text);
                  } else {
                    _editTeam(index, controller.text);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
            if (index != null)
              TextButton(
                onPressed: () {
                  developer.log(teams[index].name.toString());
                  _deleteTeam(index);
                  Navigator.of(context).pop();
                },
                child: const Text('Supprimer'),
              ),
          ],
        );
      },
    );
  }

  void _showPlayersDialog(int teamIndex) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Joueurs de ${teams[teamIndex].name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...teams[teamIndex].players.asMap().entries.map((entry) {
                int playerIndex = entry.key;
                String player = entry.value;
                return ListTile(
                  title: Text(player),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showPlayerDialog(teamIndex, playerIndex);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deletePlayer(teamIndex, playerIndex);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                );
              }),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Nom du joueur'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addPlayer(teamIndex, controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter joueur'),
            ),
          ],
        );
      },
    );
  }

  void _showPlayerDialog(int teamIndex, int playerIndex) {
    final TextEditingController controller = TextEditingController(
      text: teams[teamIndex].players[playerIndex],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le joueur'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nom du joueur'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _editPlayer(teamIndex, playerIndex, controller.text);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () {
                _deletePlayer(teamIndex, playerIndex);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importer une équipe'),
      ),
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
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.terraCotta,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    teams[index].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Joueurs: ${teams[index].players.join(', ')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                team: teams[index],
                              ),
                            ),
                          );
                        },
                        child: const Text('Sélectionner'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          _showTeamDialog(index: index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.group, color: Colors.white),
                        onPressed: () {
                          _showPlayersDialog(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTeamDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}