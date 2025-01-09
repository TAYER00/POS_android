
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _latitude;
  double? _longitude;
  bool _serviceEnabled = false;
   PermissionStatus? _permissionGranted;
   LocationData? _locationData;
   Location location = Location();





  @override
  void initState() {
    super.initState();
    // Demande d'autorisation et de service de localisation dès le lancement
    requestLocationPermission();
  }

  // Fonction pour demander la permission de localisation et vérifier le service
  void requestLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Si la permission est accordée, obtenir les coordonnées
    _getLocation();
  }

  // Fonction pour récupérer la localisation
  void _getLocation() async {
    try {
      _locationData = await location.getLocation();
      setState(() {
        _latitude = _locationData?.latitude;
        _longitude = _locationData?.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Location"),
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text("Get Location"),
            ), // ElevatedButton
            const SizedBox(height: 20), // SizedBox
            _latitude != null && _longitude != null
                ? Column(
              children: [
                Text("Latitude: $_latitude"),
                Text("Longitude: $_longitude"),
              ],
            )
                : const Text("Location not yet retrieved"),
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}
