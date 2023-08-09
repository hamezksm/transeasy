import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DataService {
  Future<List<String>> getDestinations() async {
    final jsonStr = await rootBundle.loadString('lib/model/route.json');
    final jsonData = json.decode(jsonStr);

    List<String> destinations = [];
    for (var route in jsonData['routes']) {
      if (route['destinations'] != null) {
        destinations.addAll(route['destinations'].cast<String>());
      }
    }

    return destinations;
  }

  Future<Map<String, double>> getDestinationCoordinates(String destination) async {
    final jsonStr = await rootBundle.loadString('lib/model/route.json');
    final jsonData = json.decode(jsonStr);

    for (var route in jsonData['routes']) {
      if (route['destinations'] != null && route['destinations'].contains(destination)) {
        return {
          'latitude': route['lat'],   // Replace with the actual key for latitude
          'longitude': route['long'], // Replace with the actual key for longitude
        };
      }
    }

    return {};
  }
}
