import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rafale/utils/app_colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'countries.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game_bus_screen.dart';

class DestinationBusScreen extends StatelessWidget {
  // Constructor
  DestinationBusScreen({super.key}) : selectedCountry = Destination('', 0, 0);

  // Pays sélectionné dans le dropdown
  Destination selectedCountry;
  // Pour l'autocomplétion des pays
  final countries = getCountries();
  final TextEditingController _controller = TextEditingController();

  // Check les droits et récupère la position actuelle si possible
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and inform the user.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returns true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, int>> getNbCarte(context) async {
    var url = Uri.parse('http://10.0.2.2:6000/api/bus');

    try {
      var currentPosition = await getCurrentPosition();
      if (currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La permission pour accéder à la position n\'a pas été autorisée.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return {
          'nbCarte': 0,
          'nbCheckpoint': 0
        }; 
      } else {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "latitude1": currentPosition.latitude,
            "longitude1": currentPosition.longitude,
            "latitude2": selectedCountry.latitude,
            "longitude2": selectedCountry.longitude,
          }),
        );
          var data = jsonDecode(response.body)['data'];
          return {
            'nbCarte': data['nbCarte'],
            'nbCheckpoint': data['nbCheckpoint'],
          };
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erreur lors de la sélection de la destination.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return {
        'nbCarte': 0,
        'nbCheckpoint': 0
      }; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destination Bus'),
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Votre déstination...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return countries
                          .where((destination) => destination.name
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.name),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _controller.text = suggestion.name;
                      selectedCountry = suggestion;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final Map<String, int> nbCarte = await getNbCarte(context);
                      if (nbCarte['nbCarte'] != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameBusScreen(nbCarte: nbCarte['nbCarte'],nbCheckpoint: nbCarte['nbCheckpoint'],),
                          ),
                        );
                      }
                    },
                    child: const Text('Valider'),
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
