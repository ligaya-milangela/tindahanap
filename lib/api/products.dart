import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String productId;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  const Product({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

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
    debugPrint('Error creating store product: $e');
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
    debugPrint('Error getting store products: $e');
    rethrow;
  }
  
  return products;
}