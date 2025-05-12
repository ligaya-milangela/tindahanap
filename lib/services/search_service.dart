import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import '../api/stores.dart';
import '../models/filters.dart';
import '../models/store.dart';

Future<List<Store>> searchStores(Filters filters) async {
  Position userPosition = await getUserLocation();
  List<Store> stores = await getStores();

  stores = stores.where((store) => store.name.contains(filters.query)).toList(); // Filter by store name
  // Filter by product categories
  // Filter by user proximity
  // Filter by product names

  // Sort in order of proximity from user
  stores.sort((a, b) {
    double distanceA = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, a.latitude, a.longitude);
    double distanceB = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, b.latitude, b.longitude);
    return distanceA.truncate() - distanceB.truncate();
  });

  stores.add(Store(
    storeId: 'example',
    name: 'Really Long Name to Test Multi Line Store Names Wawawawawawawa',
    address: 'Ateneo Ave, Naga',
    latitude: 13.6303,
    longitude: 123.1851,
    blurb: 'Ateneo de Naga University and also referred to by its acronym AdNU, is a private Catholic Jesuit basic and higher education institution run by the Philippine Province of the Society of Jesus in Naga City, Camarines Sur, Philippines.',
    phoneNumber: '(054) 881 2368',
    imageUrl: '',
  ));

  return stores;
}

/*Future<List<dynamic>> fetchNearbyStores(double lat, double lon) async {
  final radius = 2000; // 2 km radius
  final url = Uri.parse(
    'https://overpass-api.de/api/interpreter?data=[out:json];('
    'node["shop"="convenience"](around:$radius,$userLatitude,$userLongitude);'
    'node["shop"="general"](around:$radius,$userLatitude,$userLongitude)["amenity"!~"gas_station"];'
    'node["shop"="sari_sari"](around:$radius,$userLatitude,$userLongitude);'
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
}*/