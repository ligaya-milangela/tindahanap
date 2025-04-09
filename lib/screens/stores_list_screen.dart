import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../widgets/store_card.dart';

class StoresListScreen extends StatefulWidget {
  const StoresListScreen({super.key});

  @override
  State<StoresListScreen> createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  final LocationService _locationService = LocationService(); // Instantiate the service
  late double userLat;
  late double userLon;
  List stores = [];
  bool isFetchingStores = true;
  
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          color: colorScheme.primary,
          height: 128.0,
        ),

        Padding(
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
                  decoration: InputDecoration(
                    hintText: 'Search for stores or products...',
                    suffixIcon: const Icon(Icons.tune),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHigh,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),

              _buildStoresList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoresList() {    
    if (isFetchingStores) {
      return const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: CircularProgressIndicator(),
      );
    }

    return Expanded(
      child: stores.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text('No stores available.'),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StoreCard(store: stores[index]),
            ),
            itemCount: stores.length,
          ),
    );
  }
}