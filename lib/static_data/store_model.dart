class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class Store {
  final String name;
  final double lat;
  final double lng;
  final String details;
  final List<Product> products;

  Store({
    required this.name,
    required this.lat,
    required this.lng,
    required this.details,
    required this.products,
  });
}
