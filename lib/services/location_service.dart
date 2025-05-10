import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> getUserLocation() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    throw const LocationServiceDisabledException();
  }

  await _getLocationPermission();
  return await Geolocator.getCurrentPosition();
}

Future<String> getPlacemarkName(double latitude, double longitude) async {
  try {
    List<Placemark> placemarkList = await placemarkFromCoordinates(latitude, longitude);
    if (placemarkList.isEmpty) {
      return '(${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}})';
    }

    Placemark placemark = placemarkList[0]; // placemarkFromCoordinate() will always return at least one
    return '${placemark.name}, ${placemark.thoroughfare}';
  } catch (e) {
    return 'UNDEFINED';
  }
}

double getDistanceFromUser(double userLatitude, double userLongitude, double storeLatitude, double storeLongitude) {
  double distanceInMeters = Geolocator.distanceBetween(
    userLatitude,
    userLongitude,
    storeLatitude,
    storeLongitude,
  );

  // Round distance by 10
  distanceInMeters /= 10;
  distanceInMeters = distanceInMeters.truncateToDouble() * 10;
  return distanceInMeters;
}

String distanceToString(double distance) {
  final int meterThreshold = 600; // Arbitrary, start using km at 600m

  if (distance < meterThreshold) {
    return '${distance.toInt()} m';
  } else {
    distance /= 1000;
    return '${distance.toStringAsFixed(1)} km';
  }
}

Future<LocationPermission> _getLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      throw const PermissionDeniedException('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw const PermissionDeniedException('Location permissions are permanently denied. Please enable them in your device settings.');
  }
  
  return permission;
}