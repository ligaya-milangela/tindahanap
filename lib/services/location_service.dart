import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Gets the user's current location
  Future<Position> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Gets the readable placemark name from coordinates
  Future<String> getPlacemarkName(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return '${p.locality}, ${p.administrativeArea}';
      }
      return 'Unknown Location';
    } catch (e) {
      return 'Unknown Location';
    }
  }

  /// Mock function to simulate fetching nearby stores
  Future<List<Map<String, dynamic>>> fetchNearbyStores(double lat, double lon) async {
    return [
      {
        'name': 'Mock Store A',
        'lat': lat + 0.001,
        'lon': lon + 0.001,
      },
      {
        'name': 'Mock Store B',
        'lat': lat - 0.001,
        'lon': lon - 0.001,
      },
    ];
  }

  /// Calculates distance in meters between user and store
  static Future<double> getDistance(double storeLat, double storeLon) async {
    final distance = Distance();
    final Position user = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return distance.as(
      LengthUnit.Meter,
      LatLng(user.latitude, user.longitude),
      LatLng(storeLat, storeLon),
    );
  }

  /// Converts distance to a readable string
  static String distanceToString(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }
}
