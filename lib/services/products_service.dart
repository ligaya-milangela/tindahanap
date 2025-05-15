import '../api/products.dart';
import '../models/product.dart';

Future<List<Product>> getStoreProducts(String storeId) async {
  const List<String> categories = ['Food', 'Drinks', 'Hygiene', 'Medicine', 'Household'];
  List<Product> products = await getProducts(storeId);

  // Sort by category: Food, Drinks, Hygiene, Medicine, Household
  products.sort((a, b) => categories.indexOf(a.category) - categories.indexOf(b.category));

  return products;
}