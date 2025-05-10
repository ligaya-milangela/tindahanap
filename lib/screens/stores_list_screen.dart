import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../widgets/inherited_user_location.dart';
import '../widgets/location_button.dart';
import '../widgets/store_card.dart';

class StoresListScreen extends StatefulWidget {
  const StoresListScreen({super.key});

  @override
  State<StoresListScreen> createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  List stores = [];
  bool isFetchingStores = true;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 116.0),
          color: colorScheme.primary,
          width: double.infinity,
          height: double.infinity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: _buildStoresList(),
          ),
        ),
        
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
                    offset: const Offset(0.0, 12.0),
                    blurRadius: 12.0,
                  )],
                ),
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
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: StoreCard(store: store, userLocation: UserLocation.of(context).location),
        );
      },
    );
  }

  Future<void> _fetchStores() async {
    try {
      final fetchedStores = await searchStores('', {});

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
