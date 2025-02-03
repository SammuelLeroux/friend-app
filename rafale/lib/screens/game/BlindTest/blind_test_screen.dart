import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rafale/utils/app_colors.dart';

class BlindTestScreen extends StatefulWidget {
  const BlindTestScreen({super.key});

  @override
  BlindTestState createState() => BlindTestState();
}

class Track {
  final String title;
  final String url;
  final String artiste;
  final String imageUrl;

  Track({
    required this.title,
    required this.url,
    required this.artiste,
    required this.imageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['Title'],
      url: json['Url'],
      artiste: json['Artiste'],
      imageUrl: json['ImageUrl'],
    );
  }
}

class BlindTestState extends State<BlindTestScreen> {
  final player = AudioPlayer();
  List<Track> tracks = [];
  bool played = false;
  String goodAnswer = '';
  String? userGuess;
  Track? goodAnswerTrack;
  int score = 0;
  bool isPlayed = true;
  bool revealAnswers = false;
  int currentRound = 1;
  final int totalRounds = 5;

  @override
  void initState() {
    super.initState();
    fetchRandomTracks();
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  Future<void> fetchRandomTracks() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:6000/api/blindtest/randomTracks'));
    if (response.statusCode == 200) {
      List<dynamic> tracksJson = jsonDecode(response.body);
      setState(() {
        tracks =
            tracksJson.map((trackJson) => Track.fromJson(trackJson)).toList();
        goodAnswerTrack = tracks[Random().nextInt(tracks.length)];
        goodAnswer = goodAnswerTrack!.title;
        player.play(UrlSource(goodAnswerTrack!.url));
      });
    } else {
      fetchRandomTracks();
    }
  }

  void _submitGuess(String guess) {
    setState(() {
      userGuess = guess;
      played = true;
      revealAnswers = false;
      isPlayed = false;
    });
  }

  void revealCorrectAnswer() {
    setState(() {
      revealAnswers = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      newRound();
    });
  }

  void newRound() async {
    player.stop();
    await fetchRandomTracks();
    setState(() {
      if (currentRound < totalRounds) {
        currentRound++;
      } else {
        currentRound = 1;
        score = 0;
      }
      userGuess = null;
      played = false;
      isPlayed = true;
      revealAnswers = false;
    });
  }

  Widget buildTrackButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: tracks.map((track) {
        bool isCorrect = track.title == goodAnswer;
        bool isSelected = userGuess == track.title;
        Color buttonColor;

        if (revealAnswers) {
          if (isCorrect) {
            buttonColor = Colors.green;
          } else if (isSelected && !isCorrect) {
            buttonColor = Colors.red;
          } else {
            buttonColor = AppColors.yellowOrange;
          }
        } else {
          buttonColor = isSelected
              ? Colors.lightBlueAccent.withOpacity(0.8)
              : AppColors.yellowOrange;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: !played ? () => _submitGuess(track.title) : null,
              splashColor: AppColors.terraCotta.withOpacity(0.3),
              highlightColor: AppColors.yellowOrange.withOpacity(0.2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        track.imageUrl,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: Text(
                        '${track.title} - ${track.artiste}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalRounds, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < currentRound ? AppColors.terraCotta : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Blind Test'),
      ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'lib/assets/logoBlindTest.png',
                    height: screenHeight * 0.25, // Logo agrandi
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                buildProgressIndicator(),
                const SizedBox(height: 16),
                Expanded(child: buildTrackButtons()),
                if (played)
                  ElevatedButton(
                    onPressed: revealCorrectAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      backgroundColor: AppColors.terraCotta,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Suivant',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
