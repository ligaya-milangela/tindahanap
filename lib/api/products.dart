import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

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
        price: doc['price'],
        imageUrl: doc['imageUrl'],
      ));
    }
  } catch (e) {
    print('Error getting store products: $e');
    rethrow;
  }
  
  return products;
}