class Product {
  String productId;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    this.productId = '',
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}