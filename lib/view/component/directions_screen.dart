import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatelessWidget {
  final LocationData currentLocation;
  final String destination;

  // Add the destination's latitude and longitude as constructor parameters
  final double destinationLatitude; // Change this
  final double destinationLongitude; // Change this

  const MapScreen({super.key, 
    required this.currentLocation,
    required this.destination,
    required this.destinationLatitude,
    required this.destinationLongitude,
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
            target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              ),
              infoWindow: const InfoWindow(title: 'Current Location'),
            ),
            Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(destinationLatitude, destinationLongitude),
              infoWindow: const InfoWindow(title: 'Destination'),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('walkingRoute'),
              color: Colors.blue,
              width: 5,
              points: [
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
                LatLng(destinationLatitude, destinationLongitude),
              ],
            ),
          },
        ),
      ),
    );
  }
}
