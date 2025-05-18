import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/filters.dart';
import '../models/store.dart';
import '../services/search_service.dart';
import '../theme/custom_colors.dart';
import '../widgets/filters_bottom_sheet.dart';
import '../widgets/inherited_shared_data.dart';
import '../widgets/location_button.dart';
import '../widgets/store_card.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapState();
}

class _StoresMapState extends State<StoresMapScreen> {
  final TextEditingController searchController = TextEditingController();
  final MapController mapController = MapController();
  late List<Store> stores;
  late Store selectedStore;
  bool isFetchingStores = true;
  bool hasSelectedStore = false;
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final SharedData sharedData = SharedData.of(context);
    final Position userLocation = sharedData.location;
    searchController.text = sharedData.filters.query;
    
    if (!isInitialized) {
      _fetchStores(sharedData.location, sharedData.filters);
    }

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
                const LocationButton(),
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
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for stores or products...',
                      suffixIcon: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() => hasSelectedStore = false);
                        _showFiltersBottomSheet(sharedData);
                      },
                      child: const Icon(Icons.tune),
                    ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: (String value) {
                      sharedData.filters.query = value.toLowerCase();
                      _fetchStores(sharedData.location, sharedData.filters);
                    },
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
        backgroundColor: colorScheme.primaryContainer,
        elevation: 3.0,
        onPressed: () => mapController.move(
          LatLng(userLocation.latitude, userLocation.longitude),
          mapController.camera.zoom
        ),
        child: const Icon(
          Icons.location_searching_outlined,
          size: 28.0,
          weight: 700.0
        ),
      ),
    );
  }

  Widget _buildStoresMap(BuildContext context) {
    final Position userLocation = SharedData.of(context).location;

    return FlutterMap(
      mapController: mapController,
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
        _buildUserLocationCircle(),
        _buildUserLocationMarker(),
        if (!isFetchingStores)
          _buildStoreMarkers(),
      ],
    );
  }

  Widget _buildUserLocationCircle() {
    final CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
    final Position userLocation = SharedData.of(context).location;
    
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

  Widget _buildStoreMarkers() {
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
              mapController.move(storePoint, mapController.camera.zoom);
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

  Widget _buildUserLocationMarker() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
    final Position userLocation = SharedData.of(context).location;

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

  Future<void> _showFiltersBottomSheet(SharedData sharedData) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SharedData(
          filters: sharedData.filters,
          location: sharedData.location,
          child: const FiltersBottomSheet(),
        );
      },
      showDragHandle: true,
    );
    _fetchStores(sharedData.location, sharedData.filters);
  }

  Future<void> _fetchStores(Position userLocation, Filters filters) async {
    try {
      setState(() {
        isFetchingStores = true;
        hasSelectedStore = false;
      });
      final List<Store> fetchedStores = await searchStores(userLocation, filters);
      setState(() {
        stores = fetchedStores;
        isFetchingStores = false;
        isInitialized = true;
      });
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() {
        stores = [];
        isFetchingStores = false;
      });
    }
  }
}
