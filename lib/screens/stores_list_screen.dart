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
  final LocationService _locationService = LocationService();
  late double userLat;
  late double userLon;
  List stores = [];
  bool isFetchingStores = true;
  
  // Get the user's current location and fetch nearby stores
  Future<void> _initializeLocationAndStores() async {
    try {
      final Position position = await _locationService.getUserLocation();

      // Widget state can only be changed if it is still mounted
      // If no longer mounted, exit immediately
      if (!mounted) return;
      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
      });

      final fetchedStores = await _locationService.fetchNearbyStores(userLat, userLon);

      // Widget state can only be changed if it is still mounted
      // If no longer mounted, exit immediately
      if (!mounted) return;
      setState(() {
        stores = fetchedStores;
        isFetchingStores = false;
      });
    } catch (e) {
      // Widget state can only be changed if it is still mounted
      if (mounted) {
        setState(() {
          stores = [];
          isFetchingStores = false;
        });
      }
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
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 128.0),
              
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  width: double.infinity,
                  child: _buildStoresList(),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          width: double.infinity,
          height: 164.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoresList() {    
    if (isFetchingStores) {
      return const Center(child: CircularProgressIndicator());
    }
    if (stores.isEmpty) {
      return const Center(child: Text('No stores available.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 32.0,
        bottom: 16.0,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: StoreCard(store: stores[index]),
      ),
      itemCount: stores.length,
    );
  }
}