import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMapScreen> {
  final LocationService _locationService = LocationService(); // Instantiate the service
  late double userLat;
  late double userLon;

  List stores = []; // Full list of stores from API
  List filteredStores = []; // Filtered list based on search

  bool isFetchingStores = true;

  TextEditingController _searchController = TextEditingController(); // For search bar


  
  // Get the user's current location and fetch nearby stores
  Future<void> _initializeLocationAndStores() async {
    try {
      final Position position = await _locationService.getUserLocation();

      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
        isFetchingStores = true;
      });

     final fetchedStores = await _locationService.fetchNearbyStores(userLat, userLon);

    setState(() {
      stores = fetchedStores;
      filteredStores = fetchedStores; // Initialize filtered list
      isFetchingStores = false;
    });
    } catch (e) {
      setState(() {
        stores = [];
        isFetchingStores = false;
      });
      debugPrint('Error initializing location and stores: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocationAndStores();
  }
  void _filterStores(String query) {
  if (query.isEmpty) {
    setState(() {
      filteredStores = List.from(stores);
    });
    return;
  }

  setState(() {
    filteredStores = stores.where((store) {
      final name = store['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        isFetchingStores
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(userLat, userLon),
                initialZoom: 17.0,
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    const LatLng(13.653928325123845, 123.16081093961249), 
                    const LatLng(13.60336492810391, 123.24656402984871)
                  )
                ),
                minZoom: 15.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                 markers: filteredStores.map((store) {
                    return Marker(
                      point: LatLng(store['lat'], store['lon']),
                      child: Icon(
                        Icons.location_on,
                        size: 40.0,
                        color: colorScheme.primaryContainer,
                        shadows: [
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        

        Container(
          padding: const EdgeInsets.fromLTRB(32.0, 36.0, 32.0, 0.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {},
                  style: const ButtonStyle(alignment: Alignment(-1.0, 0.0)),
                  icon: const Icon(Icons.near_me),
                  label: isFetchingStores
                    ? const Text('Fetching location...')
                    : Text('Lat: $userLat, Lon: $userLon'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  groupId: TextField( controller: _searchController, onChanged: _filterStores, decoration: InputDecoration(
                    hintText: 'Search for stores or products...',
                    suffixIcon: const Icon(Icons.tune),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHigh,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
