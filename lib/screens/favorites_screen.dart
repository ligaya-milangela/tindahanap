import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../widgets/store_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final LocationService _locationService = LocationService();
  late double userLat;
  late double userLon;
  List stores = [];
  bool isFetchingStores = true;

  // Get the user's current location and fetch favorite stores
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

      // API call should fetch user's favorite stores
      // Sorted by proximity from current location
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.primary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            width: double.infinity,
            height: 116.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorites',
                  style: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your bookmarked sari-sari stores',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

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
      itemBuilder: (context, index) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: StoreCard(store: stores[index]),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton.filledTonal(
              onPressed: () {},
              isSelected: true,
              selectedIcon: const Icon(Icons.favorite),
              icon: const Icon(Icons.favorite_outline),
            ),
          ),
        ],
      ),
      itemCount: stores.length,
    );
  }
}