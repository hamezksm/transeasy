import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:trans_e/view/widgets/search_bar.dart';
import 'directions_screen.dart'; // Import your MapScreen
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location loc = Location();
  LocationData? _currentLocation;
  String? _selectedDestination;
  double? _destinationLatitude;
  double? _destinationLongitude;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    // Fetch destination coordinates using Google Geocoding API
    if (_selectedDestination != null) {
      const apiKey =
          'AIzaSyDJuvvHiJHEqEQVWHAXklkxk8_ntygh8U0'; // Replace with your actual API key
      final apiUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$_selectedDestination&key=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Geocoding API Response: $data');
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          setState(() {
            _destinationLatitude = location['lat'];
            _destinationLongitude = location['lng'];
          });
          developer.log(
            'log me',
            name: 'my.app.category',
            error: jsonDecode(data),
          );
          // stderr.writeIn('print');
          print(response.body);
        } else {
          // Handle API error
          print('Big error');
        }
      } else {
        // Handle HTTP error
        print('Much larger error');
      }
    }

    // Fetch current location and permissions
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await loc.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await loc.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await loc.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await loc.getLocation();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: const Text('Trans-E'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchWidget(
              onDestinationSelected: (destination) {
                setState(() {
                  _selectedDestination = destination;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
              onPressed: () {
                if (_currentLocation != null &&
                    _destinationLatitude != null &&
                    _destinationLongitude != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        currentLocation: _currentLocation!,
                        destination: _selectedDestination!,
                        destinationLatitude: _destinationLatitude!,
                        destinationLongitude: _destinationLongitude!,
                      ),
                    ),
                  );
                } else {
                  print(_currentLocation);
                  print(_destinationLatitude);
                  print(_destinationLongitude);
                  print(_selectedDestination);
                  // print(response.body);
                }
              },
              child: const Text('Get Directions'),
            )
          ],
        ),
      ),
    );
  }
}
