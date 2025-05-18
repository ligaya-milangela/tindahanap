import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../services/sample_products.dart';
import '../services/store_seed_data.dart';

Future<void> createProduct(Product product, String storeId) async {
  try {
    await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('products')
      .add({
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'imageUrl': product.imageUrl,
      });
  } catch (e) {
    print('Error creating store product: $e');
    rethrow;
  }
}

Future<List<Product>> getProducts(String storeId) async {
  List<Product> products = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('products')
      .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      products.add(Product(
        productId: doc.id,
        name: doc['name'],
        category: doc['category'],
        price: (doc['price'] as num).toDouble(),
        imageUrl: doc['imageUrl'],
      ));
    }
  } catch (e) {
    print('Error getting store products: $e');
    rethrow;
  }
  
  return products;
}

Future<void> seedStoresAndProducts() async {
  for (final store in sampleStores) {
    final docRef = await FirebaseFirestore.instance.collection('stores').add({
      'name': store.name,
      'address': store.address,
      'latitude': store.latitude,
      'longitude': store.longitude,
      'blurb': store.blurb,
      'phoneNumber': store.phoneNumber,
      'imageUrl': store.imageUrl,
    });

    // Assign random products to each store
    for (final product in getRandomProducts()) {
      await createProduct(product, docRef.id);
    }
  }
}