import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/search_service.dart';
import '../api/stores.dart';
import '../widgets/inherited_user_location.dart';
import '../widgets/location_button.dart';
import '../widgets/store_card.dart';
import '../theme/custom_colors.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMapScreen> {
  final TextEditingController _searchController = TextEditingController(); // For search bar
  final MapController _mapController = MapController();
  late List<Store> stores;
  late Store selectedStore;
  bool isFetchingStores = true;
  bool hasSelectedStore = false;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Position userLocation = UserLocation.of(context).location;

    return Scaffold(
      body: Stack(
        children: [
          if (!isFetchingStores)
            _buildStoresMap(context),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            width: double.infinity,
            height: 152.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationButton(),
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
                  ),
                ),
              ],
            ),
          ),

          (!hasSelectedStore)
            ? const SizedBox()
            : Align(
                alignment: const Alignment(0.0, 1.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  width: double.infinity,
                  child: StoreCard(store: selectedStore, userLocation: userLocation),
                ),
              ),
          
          if (isFetchingStores)
            const Align(
              alignment: Alignment(0.0, 1.0),
              child: LinearProgressIndicator(value: null),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        onPressed: () => _mapController.move(
          LatLng(userLocation.latitude, userLocation.longitude),
          _mapController.camera.zoom
        ),
        child: const Icon(Icons.location_searching_outlined, size: 28.0, weight: 700.0,),
      ),
    );
  }

  Widget _buildStoresMap(BuildContext context) {
    final Position userLocation = UserLocation.of(context).location;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(userLocation.latitude, userLocation.longitude),
        initialZoom: 17.0,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(const LatLng(13.653928, 123.160810), const LatLng(13.603364, 123.246564)),
        ),
        minZoom: 15.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) {
          setState(() => hasSelectedStore = false);
        },
      ),
      children: [
        TileLayer(urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'),
        _buildUserLocationCircle(context),
        _buildStoreMarkers(context),
        _buildUserLocationMarker(context),
      ],
    );
  }

  Widget _buildUserLocationCircle(BuildContext context) {
    final CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
    final Position userLocation = UserLocation.of(context).location;
    
    return CircleLayer(
      circles: [
        CircleMarker(
          point: LatLng(userLocation.latitude, userLocation.longitude),
          radius: 100.0,
          color: customColors.locationContainer!.withAlpha(80),
        ),
      ],
    );
  }

  Widget _buildStoreMarkers(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MarkerLayer(
      markers: stores.map((store) {
        final LatLng storePoint = LatLng(store.latitude, store.longitude);
        double iconSize = 40.0;
        Color iconColor = colorScheme.primaryContainer;

        if (hasSelectedStore && selectedStore.storeId != store.storeId) {
          iconSize = 32.0;
          iconColor = colorScheme.inversePrimary;
        }

        return Marker(
          point: storePoint,
          child: GestureDetector(
            onTap: () {
              _mapController.move(storePoint, _mapController.camera.zoom);
              setState(() {
                selectedStore = store;
                hasSelectedStore = true;
              });
            },
            child: Icon(
              Icons.location_on,
              size: iconSize,
              color: iconColor,
              shadows: [const Shadow(offset: Offset(2.0, 2.0), blurRadius: 10.0)],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserLocationMarker(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
    final Position userLocation = UserLocation.of(context).location;

    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(userLocation.latitude, userLocation.longitude),
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
    );
  }

  void _fetchStores() async {
    try {
      final List<Store> fetchedStores = await searchStores('', {});

      if (!mounted) return;
      setState(() {
        stores = fetchedStores;
        isFetchingStores = false;
      });
    } catch (e) {
      print('Error fetching stores: $e');

      if (!mounted) return;
      setState(() {
        stores = [];
        isFetchingStores = false;
      });
    }
  }
}
