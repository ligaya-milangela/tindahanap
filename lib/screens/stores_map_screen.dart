import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front/widgets/store_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../widgets/user_location.dart';
import '../theme/custom_colors.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMapScreen> {
  final LocationService _locationService = LocationService(); // Instantiate the service
  final TextEditingController _searchController = TextEditingController(); // For search bar
  final MapController _mapController = MapController();

  double? userLat;
  double? userLon;

  List stores = []; // Full list of stores from API
  List filteredStores = []; // Filtered list based on search
  String locationName = 'Fetching location...';
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

    return Scaffold(
      body: Stack(
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
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(40),
                        offset: const Offset(0.0, 8.0),
                        blurRadius: 8.0,
                      )
                    ],
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
      ),
      floatingActionButton: (userLat != null && userLon != null)
          ? FloatingActionButton(
              elevation: 3.0,
              onPressed: () {
                _mapController.move(LatLng(userLat!, userLon!), _mapController.camera.zoom);
              },
              child: const Icon(
                Icons.location_searching_outlined,
                size: 28.0,
                weight: 700.0,
              ),
            )
          : null,
    );
  }

  Widget _buildStoresMap(BuildContext context) {
    if (isFetchingStores || userLat == null || userLon == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(userLat!, userLon!),
        initialZoom: 17.0,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(13.653928325123845, 123.16081093961249),
            const LatLng(13.60336492810391, 123.24656402984871),
          ),
        ),
        minZoom: 15.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) {
          setState(() => selectedStore = null);
        },
      ),
      children: [
        TileLayer(urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'),

        // User location circle
        CircleLayer(
          circles: [
            CircleMarker(
              point: LatLng(userLat!, userLon!),
              radius: 100.0,
              color: customColors.locationContainer!.withAlpha(80),
            ),
          ],
        ),

        // Store markers
        MarkerLayer(
          markers: stores.map((store) {
            LatLng storePoint = LatLng(store['lat'], store['lon']);
            double iconSize;
            Color iconColor;

            if (selectedStore == null || selectedStore == store) {
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
                  shadows: const [Shadow(offset: Offset(2.0, 2.0), blurRadius: 10.0)],
                ),
              ),
            );
          }).toList(),
        ),

        // User location marker
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(userLat!, userLon!),
              width: 25.0,
              height: 25.0,
              child: Container(
                decoration: BoxDecoration(
                  color: customColors.location,
                  border: Border.all(color: colorScheme.surface, width: 3.0),
                  boxShadow: [BoxShadow(color: customColors.onLocationContainer!, blurRadius: 10.0)],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _initializeLocationAndStores() async {
    try {
      final Position position = await _locationService.getUserLocation();
      final placemarkName = await _locationService.getPlacemarkName(position.latitude, position.longitude);
      final fetchedStores = await _locationService.fetchNearbyStores(position.latitude, position.longitude);
      final combinedStores = [...fetchedStores];

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
        locationName = 'ERROR: Failed fetching location';
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
