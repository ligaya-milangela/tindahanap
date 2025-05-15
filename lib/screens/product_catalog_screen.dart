import 'package:flutter/material.dart';
import 'package:front/services/business_hours_service.dart';
import 'package:geolocator/geolocator.dart';
import '../models/business_hours.dart';
import '../models/favorite_store.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../services/location_service.dart';
import '../services/products_service.dart';
import '../services/favorites_service.dart';
import '../widgets/inherited_shared_data.dart';
import '../widgets/product_list_item.dart';
import 'store_details_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  final Store store;

  const ProductCatalogScreen({
    super.key,
    required this.store,
  });

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final categoryKeys = List<GlobalKey>.generate(5, (i) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final distance = LocationService.getDistance(widget.store['lat'], widget.store['lon']);
    List<ProductListItem> productListItems = [];

    for (int i = 0; i < widget.productCategories.length; i++) {
      String category = widget.productCategories[i];
      GlobalKey key = categoryKeys[i];

      productListItems.addAll([
        CategoryItem(category, key),
        ..._generateProductListItems(category),
      ]);
    }    

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.store.name,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.place,
                  size: 16.0,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  '${LocationService.distanceToString(distance)} away',
                  style: textTheme.titleSmall?.copyWith(color: colorScheme.onSecondaryContainer),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreDetailsScreen(
                  store: widget.store,
                  storeBusinessHours: storeBusinessHours,
                )),
              );
            },
            icon: const Icon(Icons.store, size: 28.0),
          ),
          IconButton(
            onPressed: _onFavorite,
            isSelected: favoriteStore.favoriteId != '',
            selectedIcon: const Icon(Icons.favorite_rounded, size: 28.0),
            icon: const Icon(Icons.favorite_outline_rounded, size: 28.0),
          ),
        ],
        bottom: (isLoading || productCategories.isEmpty)
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
                ),
                width: double.infinity,
                height: 80.0,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Wrap(
                      spacing: 16.0,
                      children: _buildCategoryChips(),
                    ),
                  ),
                ),
              ),
            ),
        shadowColor: colorScheme.shadow,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        toolbarHeight: 64.0,
        actionsPadding: const EdgeInsets.only(right: 8.0),
      ),
      body: _buildBody(),
    );
  }

  List<Widget> _buildCategoryChips() {
    List<Widget> categoryChips = [];

    for (int i = 0; i < productCategories.length; i++) {
      categoryChips.add(ActionChip(
        label: Text(productCategories[i]),
        onPressed: () {
          Scrollable.ensureVisible(
            categoryKeys[i].currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ));
    }

    return categoryChips;
  }

  List<ProductListItem> _generateProductListItems(String category) {
    // Fetch products according to category
    // Generate list of ProductItems
    
    // Placeholder items for now
    return [
      ProductItem('Product Name', 'PHP 25.00 [/ unit]'),
      ProductItem('Product Name', 'PHP 25.00 [/ unit]'),
      ProductItem('Product Name', 'PHP 25.00 [/ unit]'),
      ProductItem('Product Name', 'PHP 25.00 [/ unit]'),
      ProductItem('Product Name', 'PHP 25.00 [/ unit]'),
    ];
  }
}
