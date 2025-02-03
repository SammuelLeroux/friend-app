import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rafale/screens/game/course/course_classement_screen.dart';

class GameCourseScreen extends StatefulWidget {
  final Map<String, String> choicePlayer;
  const GameCourseScreen({super.key, required this.choicePlayer});

  @override
  GameCourseScreenState createState() => GameCourseScreenState();
}

class GameCourseScreenState extends State<GameCourseScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late Animation<double> _rotationAnimation1;
  late Animation<double> _rotationAnimation2;
  late Animation<double> _rotationAnimation3;
  late Animation<double> _rotationAnimation4;
  late Animation<double> _positionAnimation1;
  late Animation<double> _positionAnimation2;
  late Animation<double> _positionAnimation3;
  late Animation<double> _positionAnimation4;

  final List<List<dynamic>> classement = [];

  int randomDuration() {
    // Random duration between 4 and 10 seconds
    return Random().nextInt(7) + 4;
  }

  @override
  void initState() {
    super.initState();
  
    _controller1 = AnimationController(
      duration: Duration(seconds: randomDuration()),
      vsync: this,
    )..forward();
    
    classement.add([_controller1.duration!.inSeconds, 'Kro rouge']);

    _controller2 = AnimationController(
      duration: Duration(seconds: randomDuration()),
      vsync: this,
    )..forward();

      classement.add([_controller2.duration!.inSeconds, 'Kro jaune']);

    _controller3 = AnimationController(
      duration: Duration(seconds: randomDuration()),
      vsync: this,
    )..forward();

    classement.add([_controller3.duration!.inSeconds, 'Kro bleue']);

    _controller4 = AnimationController(
      duration: Duration(seconds: randomDuration()),
      vsync: this,
    )..forward();

    classement.add([_controller4.duration!.inSeconds, 'Kro violet']);

    _rotationAnimation1 = Tween<double>(begin: 0, end: 2 * 3.141592653589793)
        .animate(_controller1);
    _rotationAnimation2 = Tween<double>(begin: 0, end: 2 * 3.141592653589793)
        .animate(_controller2);
    _rotationAnimation3 = Tween<double>(begin: 0, end: 2 * 3.141592653589793)
        .animate(_controller3);
    _rotationAnimation4 = Tween<double>(begin: 0, end: 2 * 3.141592653589793)
        .animate(_controller4);

    _positionAnimation1 =
        Tween<double>(begin: 1, end: -1).animate(_controller1);
    _positionAnimation2 =
        Tween<double>(begin: 1, end: -1).animate(_controller2);
    _positionAnimation3 =
        Tween<double>(begin: 1, end: -1).animate(_controller3);
    _positionAnimation4 =
        Tween<double>(begin: 1, end: -1).animate(_controller4);

    classement.sort((a, b) => a[1].compareTo(a[1]));
    
    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationEnd(1);
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationEnd(2);
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationEnd(3);
      }
    });
    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationEnd(4);
      }
    });
  }
  
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  void _onAnimationEnd(int controllerIndex) {
    if (_controller1.isCompleted &&
        _controller2.isCompleted &&
        _controller3.isCompleted &&
        _controller4.isCompleted) {
      _allAnimationsCompleted();
    }
  }


  void _allAnimationsCompleted() {
    List<List<dynamic>> resultat = [];

    // Itération sur le tableau classement
    for (var item in classement) {
      int entier = item[0];
      String couleur = item[1];
      String joueur = widget.choicePlayer[couleur] ?? 'inconnu'; 

      // Ajout de la combinaison (entier, couleur, nom du joueur) au nouveau tableau
      resultat.add([entier, couleur, joueur]);
    }

    // Tri du tableau resultat par ordre croissant de entier
    resultat.sort((a, b) => a[0].compareTo(b[0]));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassementCourseScreen(classementList: resultat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course de Kro',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "lib/assets/damier.png",
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final double screenHeight = constraints.maxHeight;
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller1,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0,
                                _positionAnimation1.value * screenHeight - 50),
                            child: Transform.rotate(
                              angle: _rotationAnimation1.value,
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset("lib/assets/bottleRed.png",
                            width: 100, height: 100),
                      ),
                      AnimatedBuilder(
                        animation: _controller2,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0,
                                _positionAnimation2.value * screenHeight - 50),
                            child: Transform.rotate(
                              angle: _rotationAnimation2.value,
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset("lib/assets/bottleYellow.png",
                            width: 100, height: 100),
                      ),
                      AnimatedBuilder(
                        animation: _controller3,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0,
                                _positionAnimation3.value * screenHeight - 50),
                            child: Transform.rotate(
                              angle: _rotationAnimation3.value,
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset("lib/assets/bottleBlue.png",
                            width: 100, height: 100),
                      ),
                      AnimatedBuilder(
                        animation: _controller4,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0,
                                _positionAnimation4.value * screenHeight - 50),
                            child: Transform.rotate(
                              angle: _rotationAnimation4.value,
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset("lib/assets/bottlePink.png",
                            width: 100, height: 100),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
