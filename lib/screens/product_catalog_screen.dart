import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/products_service.dart';
import '../api/stores.dart';
import '../api/products.dart';
import '../widgets/inherited_user_location.dart';
import '../widgets/product_list_item.dart';
import 'store_details_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  final List<String> productCategories = const ['Food', 'Drinks', 'Hygiene', 'Medicine', 'Household'];
  final Store store;

  const ProductCatalogScreen({
    super.key,
    required this.store,
  });

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final List<GlobalKey> categoryKeys = List<GlobalKey>.generate(5, (i) => GlobalKey());
  late List<Product> products;
  List<ProductListItem>  productListItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Position userLocation = UserLocation.of(context).location;
    final distanceFromUser = getDistanceFromUser(
      userLocation.latitude,
      userLocation.longitude,
      widget.store.latitude,
      widget.store.longitude
    );

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
              spacing: 4.0,
              children: [
                Icon(
                  Icons.place,
                  size: 16.0,
                  color: colorScheme.onSecondaryContainer,
                ),
                
                Text(
                  '${distanceToString(distanceFromUser)} away',
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
                MaterialPageRoute(builder: (context) => StoreDetailsScreen(store: widget.store)),
              );
            },
            icon: const Icon(Icons.store, size: 28.0),
          ),
          IconButton(
            onPressed: () {},
            isSelected: false,
            selectedIcon: const Icon(Icons.favorite_rounded, size: 28.0),
            icon: const Icon(Icons.favorite_outline_rounded, size: 28.0),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
            ),
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

    for (int i = 0; i < widget.productCategories.length; i++) {
      categoryChips.add(ActionChip(
        label: Text(widget.productCategories[i]),
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

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productListItems.isEmpty) {
      return const Center(child: Text('No favorite stores.'));
    }
    
    _generateProductListItems();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 64.0),
      child: Column(
        children: productListItems.map((item) => ListTile(
          key: item.getKey(),
          leading: item.buildLeading(context),
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
          minVerticalPadding: 12.0,
        )).toList(),
      ),
    );    
  }

  void _fetchProducts() async {
    try {
      final List<Product> fetchedProducts = await getStoreProducts(widget.store.storeId);
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching store products: $e');
      setState(() {
        products = [];
        isLoading = false;
      });
    }
  }

  void _generateProductListItems() {
    String currentCategory = '';
    int categoryKeyIndex = 0;

    for (Product product in products) {
      if (product.category != currentCategory) {
        currentCategory = product.category;
        productListItems.add(CategoryItem(product.category, categoryKeys[categoryKeyIndex]));
        categoryKeyIndex++;
      }

      productListItems.add(ProductItem(product.name, 'PHP ${product.price}'));
    }
  }
}