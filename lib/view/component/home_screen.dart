import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trans_e/view/widgets/search_bar.dart';
import 'directions_screen.dart'; // Import your MapScreen
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_polyline/google_maps_polyline.dart';

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
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationAndPermissions();
  }

  void _fetchDestinationCoordinates() async {
    // Fetch Destination coordinates using google Geocoding API
    if (_selectedDestination != null) {
      const apiKey =
          'AIzaSyDJuvvHiJHEqEQVWHAXklkxk8_ntygh8U0'; // Replace with actual API key
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

          // Fetch detailed route using Google Directions API
          final directionsResponse = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/directions/json'
            '?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
            '&destination=$_destinationLatitude,$_destinationLongitude'
            '&key=$apiKey',
          ));

          if (directionsResponse.statusCode == 200) {
            final directionsData = json.decode(directionsResponse.body);
            if (directionsData['status'] == 'OK') {
              final routes = directionsData['routes'];
              if (routes.isNotEmpty) {
                final overviewPolyline = routes[0]['overview_polyline'];
                final points = overviewPolyline['points'];

                // Decode the polyline points using GoogleMapsPolyline
                final polylinePoints =
                    GoogleMapsPolyline().decodePolyline(points);

                // Convert the List<LatLng> to List<LatLng>
                routePoints = polylinePoints
                    .map((point) => LatLng(point.latitude!, point.longitude!))
                    .toList();
              }
            }
          }
        } else {
          // Handle API error
          print('Big error');
        }
      } else {
        // Handle HTTP error
        print('Much larger error');
      }
    }
  }

  Future<void> _fetchCurrentLocationAndPermissions() async {
    // Fetch current location and permissions
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await loc.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loc.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await loc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await loc.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentLocation = await loc.getLocation();
    setState(() {});
    _fetchDestinationCoordinates();
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
              onPressed: () async {
                _fetchDestinationCoordinates();
                _currentLocation;

                // Find a way to ensure that the destination Longitude and Latitude are not null at this point.

                print("Works $_destinationLatitude");
                print("Works $_destinationLongitude");

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
                        routePoints: routePoints,
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

// new errors came up.

// You have to press the button twice. Error is noticeable from developer.log
// 