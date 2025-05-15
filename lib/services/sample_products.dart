import '../models/product.dart';
import 'dart:math';

final List<Product> allSampleProducts = [
  Product(
    productId: '',
    name: 'Instant Noodles',
    category: 'Food',
    price: 15.0,
    imageUrl: 'https://example.com/images/noodles.jpg',
  ),
  Product(
    productId: '',
    name: 'Bottled Water',
    category: 'Drinks',
    price: 10.0,
    imageUrl: 'https://example.com/images/water.jpg',
  ),
  Product(
    productId: '',
    name: 'Toothpaste',
    category: 'Hygiene',
    price: 45.0,
    imageUrl: 'https://example.com/images/toothpaste.jpg',
  ),
  Product(
    productId: '',
    name: 'Paracetamol',
    category: 'Medicine',
    price: 20.0,
    imageUrl: 'https://example.com/images/med.jpg',
  ),
  Product(
    productId: '',
    name: 'Laundry Detergent',
    category: 'Household',
    price: 55.0,
    imageUrl: 'https://example.com/images/detergent.jpg',
  ),
  Product(
    productId: '',
    name: 'Chips',
    category: 'Food',
    price: 25.0,
    imageUrl: 'https://example.com/images/chips.jpg',
  ),
  Product(
    productId: '',
    name: 'Soda Can',
    category: 'Drinks',
    price: 18.0,
    imageUrl: 'https://example.com/images/soda.jpg',
  ),
  Product(
    productId: '',
    name: 'Shampoo',
    category: 'Hygiene',
    price: 60.0,
    imageUrl: 'https://example.com/images/shampoo.jpg',
  ),
  Product(
    productId: '',
    name: 'Band-Aids',
    category: 'Medicine',
    price: 30.0,
    imageUrl: 'https://example.com/images/bandaids.jpg',
  ),
  Product(
    productId: '',
    name: 'Dishwashing Liquid',
    category: 'Household',
    price: 40.0,
    imageUrl: 'https://example.com/images/dishwashing.jpg',
  ),
  Product(
    productId: '',
    name: 'Chocolate Bar',
    category: 'Food',
    price: 35.0,
    imageUrl: 'https://example.com/images/chocolate.jpg',
  ),
];

List<Product> getRandomProducts() {
  final random = Random();
  final count = 3 + random.nextInt(4); // 3 to 6 products per store
  final shuffled = List<Product>.from(allSampleProducts)..shuffle();
  return shuffled.take(count).toList();
}
