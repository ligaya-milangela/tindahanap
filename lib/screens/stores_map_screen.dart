import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front/widgets/store_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../widgets/user_location.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMapScreen> {
  final LocationService _locationService = LocationService(); // Instantiate the service
  final TextEditingController _searchController = TextEditingController(); // For search bar
  final MapController _mapController = MapController();
  late double userLat;
  late double userLon;

  List stores = []; // Full list of stores from API
  List filteredStores = []; // Filtered list based on search
  String locationName = 'Fetching stores...';
  bool isFetchingStores = true;
  dynamic selectedStore;

  @override
  void initState() {
    super.initState();
    _initializeLocationAndStores();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        _buildStoresMap(context),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          width: double.infinity,
          height: 152.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserLocation(locationName: locationName),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: colorScheme.shadow.withAlpha(40),
                    offset: const Offset(0.0, 8.0),
                    blurRadius: 8.0,
                  )],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for stores or products...',
                    suffixIcon: const Icon(Icons.tune),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLow,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: _filterStores,
                ),
              ),
            ],
          ),
        ),

        (selectedStore == null)
          ? const SizedBox()
          : Align(
              alignment: const Alignment(0.0, 1.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                width: double.infinity,
                child: StoreCard(store: selectedStore),
              ),
            ),
      ],
    );
  }

  Widget _buildStoresMap(BuildContext context) {
    if (isFetchingStores) {
      return const Center(child: CircularProgressIndicator());
    }

    final colorScheme = Theme.of(context).colorScheme;
    
    return FlutterMap(
      mapController: _mapController,
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
        onTap: (tapPosition, point) {
          setState(() => selectedStore = null);
        },
      ),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
        MarkerLayer(
          markers: stores.map((store) {
            LatLng storePoint = LatLng(store['lat'], store['lon']);
            double iconSize;
            Color iconColor;

            if (selectedStore == null) {
              iconSize = 40.0;
              iconColor = colorScheme.primaryContainer;
            } else if (selectedStore == store) {
              iconSize = 40.0;
              iconColor = colorScheme.primaryContainer;
            } else {
              iconSize = 32.0;
              iconColor = colorScheme.inversePrimary;
            }

            return Marker(
              point: storePoint,
              child: GestureDetector(
                onTap: () {
                  _mapController.move(storePoint, _mapController.camera.zoom);
                  setState(() => selectedStore = store);
                },
                child: Icon(
                  Icons.location_on,
                  size: iconSize,
                  color: iconColor,
                  shadows: [
                    const Shadow(offset: Offset(2.0, 2.0), blurRadius: 10.0),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Get the user's current location and fetch nearby stores
  Future<void> _initializeLocationAndStores() async {
    try {
      final Position position = await _locationService.getUserLocation();
      final placemarkName = await _locationService.getPlacemarkName(position.latitude, position.longitude);
      final fetchedStores = await _locationService.fetchNearbyStores(position.latitude, position.longitude);
      final combinedStores = [...fetchedStores]; // Combine both static and dynamic stores

      if (!mounted) return;
      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
        stores = combinedStores;
        filteredStores = combinedStores;
        locationName = placemarkName;
        isFetchingStores = false;
      });
    } catch (e) {
      debugPrint('Error initializing location and stores: $e');
      if (!mounted) return;
      setState(() {
        stores = [];
        locationName = 'ERROR: Failed fetching stores';
        isFetchingStores = false;
      });
    }
  }

  void _filterStores(String query) {
    if (query.isEmpty) {
      setState(() => filteredStores = List.from(stores));
      return;
    }

    setState(() {
      filteredStores = stores.where((store) {
        final name = store['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }
}
