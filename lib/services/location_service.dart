import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Function to fetch the user's current location
  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception("Location permission is denied.");
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

Future<List<dynamic>> fetchNearbyStores(double lat, double lon) async {
  final radius = 2000; // 2 km radius
  final url = Uri.parse(
    'https://overpass-api.de/api/interpreter?data=[out:json];('
    'node["shop"="convenience"](around:$radius,$lat,$lon);'
    'node["shop"="general"](around:$radius,$lat,$lon)["amenity"!~"gas_station"];'
    'node["shop"="sari_sari"](around:$radius,$lat,$lon);'
    ');out body;>;'
  );


  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['elements'];
    } else {
      return []; // If no stores found or error
    }
  } catch (e) {
    return []; // Handle any error
  }
}


}
