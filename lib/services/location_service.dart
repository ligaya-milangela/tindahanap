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
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception('Location permission is denied.');
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

  static double getDistance(double startLatitude, double startLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      13.6303, // Replace with current location's latitude
      123.1851 // Replace with current location's longitude
    );

    // Round distance by 10
    distanceInMeters /= 10;
    distanceInMeters = distanceInMeters.truncateToDouble() * 10;
    return distanceInMeters;
  }

  static String distanceToString(double distance) {
    final int meterThreshold = 600; // Arbitrary, start using km at 600m

    if (distance < meterThreshold) {
      return '${distance.toInt()} m';
    } else {
      distance /= 1000;
      return '${distance.toStringAsFixed(1)} km';
    }
  }
}
