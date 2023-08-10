import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatelessWidget {
  final LocationData currentLocation;
  final String destination;

  // Add the destination's latitude and longitude as constructor parameters
  final double destinationLatitude; // Change this
  final double destinationLongitude; // Change this
  final List<LatLng> routePoints;
  
  const MapScreen({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.routePoints, required this.destinationLatitude, required this.destinationLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Walking Directions'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              ),
              infoWindow: InfoWindow(title: 'Current Location'),
            ),
            Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(destinationLatitude, destinationLongitude),
              infoWindow: InfoWindow(title: 'Destination'),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('walkingRoute'),
              color: Colors.blue,
              width: 5,
              points: 
                routePoints,
              
            ),
          },
        ),
      ),
    );
  }
}
