import 'package:flutter/material.dart';
import 'dart:math';
import '../static_data/product_data.dart';
import 'store_extra_details_screen.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreDetailsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String name = store['tags']?['name'] ?? 'Unnamed Store';
    String type = store['tags']?['shop'] ?? 'Unknown Type';
    String address = store['tags']?['addr:street'] ?? 'No street address';
    String city = store['tags']?['addr:city'] ?? 'No city';
    String postcode = store['tags']?['addr:postcode'] ?? 'No postcode';

    final random = Random();
    final randomProducts = List.generate(3, (_) => sampleProducts[random.nextInt(sampleProducts.length)]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.secondaryContainer,
      ),
      body: Stack(
        children: [
          Container(
            color: colorScheme.tertiary,
            width: double.infinity,
            height: 256.0,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 224.0, bottom: 24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(32.0),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.0, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4.0),
                      Text('$address, $city, $postcode', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16.0, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4.0),
                      Text(type, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),

                  const Divider(height: 32, thickness: 2, indent: 20, endIndent: 0, color: Colors.black),

                  Text('Available Products', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),

                  ...List.generate(randomProducts.length, (index) {
                    final product = randomProducts[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(product['name'] ?? 'Unnamed'),
                      trailing: Text('₱${product['price'].toString()}'),
                    );
                  }),

                  const SizedBox(height: 16.0),

                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreExtraDetailsScreen(store: store),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("See Details"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
