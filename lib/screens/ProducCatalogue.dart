import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store UI',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: StorePage(),
    );
  }
}

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<String> categories = ['Food', 'Drinks', 'Hygiene', 'Medicine', 'House'];
  String selectedCategory = 'Food';

  Map<String, List<String>> categoryProducts = {
    'Food': ['Rice', 'Bread', 'Eggs'],
    'Drinks': ['Water', 'Juice', 'Soda'],
    'Hygiene': ['Soap', 'Toothpaste'],
    'Medicine': ['Paracetamol', 'Bandages'],
    'House': ['Detergent', 'Broom'],
  };

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    List<String> displayedProducts = categoryProducts[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Store Name',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('200 m away',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                      Icon(Icons.shopping_cart_outlined),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Category Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        bool isSelected = cat == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = cat;
                              });
                            },
                            selectedColor: Colors.purple,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            // Product List
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedProducts.map((product) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: buildProductCard(product),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(String name) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: Icon(Icons.image_outlined),
        ),
        title: Text(name),
        subtitle: Text('₱10.00'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              product,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('₱10.00', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add to Cart'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$product added to cart')),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}