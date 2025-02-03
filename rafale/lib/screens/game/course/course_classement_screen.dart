import 'package:flutter/material.dart';

class ClassementCourseScreen extends StatefulWidget {
  final List<List<dynamic>> classementList;
  const ClassementCourseScreen({super.key, required this.classementList});

  @override
  ClassementCourseScreenState createState() => ClassementCourseScreenState();
}

class ClassementCourseScreenState extends State<ClassementCourseScreen> {
  void onPressedButton() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Trier le classement par temps
    widget.classementList.sort((a, b) => a[0].compareTo(b[0]));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course de Kro - Classement',
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
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
              ),
            ),
            Center(
              child: ListView.builder(
                itemCount: widget.classementList.length,
                itemBuilder: (context, index) {
                  final item = widget.classementList[index];
                  final time = item[0];
                  final color = item[1];
                  final player = item[2];

                  // Gérer les égalités
                  String position = (index + 1).toString();
                  if (index > 0 && widget.classementList[index - 1][0] == time) {
                    position = (index).toString();
                  }

                  return ListTile(
                    leading: Text(
                      position,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      player,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      color,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      '$time s',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 90.0), 
                child: ElevatedButton(
                  onPressed: onPressedButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
