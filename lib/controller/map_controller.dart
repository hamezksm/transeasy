import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final LocationData? currentLocation;

  const MapView({Key? key, this.currentLocation}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.currentLocation?.latitude ?? 0,
          widget.currentLocation?.longitude ?? 0,
        ),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
            widget.currentLocation?.latitude ?? 0,
            widget.currentLocation?.longitude ?? 0,
          ),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      },
    );
  }
}
