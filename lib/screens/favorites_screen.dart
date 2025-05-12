import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/favorites_service.dart';
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.primaryContainer,
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Your bookmarked sari-sari stores',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimaryContainer),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            CircularProgressIndicator(),
            Text('Fetching your favorite stores...'),
          ],
        ),
      );
    }
    if (stores.isEmpty) {
      return const Center(child: Text('No favorite stores.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      itemCount: stores.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: StoreCard(store: stores[index], userLocation: SharedData.of(context).location),
      ),
    );
  }

  void _fetchFavoriteStores() async {
    try {
      final fetchedStores = await getUserFavoriteStores();
      setState(() {
        stores = fetchedStores;
        isFetchingStores = false;
      });
    } catch (e) {
      print('Error fetching user favorite stores: $e');
      setState(() {
        stores = [];
        isFetchingStores = false;
      });
    }
  }
}