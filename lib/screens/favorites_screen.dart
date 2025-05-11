import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../api/stores.dart';
import '../widgets/inherited_shared_data.dart';
import '../widgets/store_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Store> stores;
  bool isFetchingStores = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteStores();
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
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Your bookmarked sari-sari stores',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
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
              child: _buildStoresList(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresList(BuildContext context) {
    if (isFetchingStores) {
      return const Center(child: CircularProgressIndicator());
    }
    if (stores.isEmpty) {
      return const Center(child: Text('No favorite stores.'));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      itemBuilder: (context, index) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: StoreCard(store: stores[index], userLocation: SharedData.of(context).location),
          ),
          
          Positioned(
            top: 12.0,
            right: 12.0,
            child: Material(
              color: colorScheme.surface.withAlpha(0),
              child: Ink(
                decoration: ShapeDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  shape: const CircleBorder(),
                ),
                width: 28.0,
                height: 28.0,
                child: IconButton(
                  iconSize: 20.0,
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  isSelected: true,
                  selectedIcon: const Icon(Icons.favorite),
                  icon: const Icon(Icons.favorite_outline),
                ),
              ),
            ),
          ),
        ],
      ),
      itemCount: stores.length,
    );
  }

  void _fetchFavoriteStores() async {
    try {
      final fetchedStores = await getUserFavoriteStores();

      if (!mounted) return;
      setState(() {
        stores = fetchedStores;
        isFetchingStores = false;
      });
    } catch (e) {
      debugPrint('Error fetching user favorite stores: $e');
      
      if (!mounted) return;
      setState(() {
        stores = [];
        isFetchingStores = false;
      });
    }
  }
}