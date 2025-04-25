import 'package:flutter/material.dart';

abstract class ProductListItem {
  GlobalKey? getKey();
  Widget? buildLeading(BuildContext context);
  Widget buildTitle(BuildContext context);
  Widget? buildSubtitle(BuildContext context);
}

class CategoryItem implements ProductListItem {
  final String category;
  final GlobalKey? key;

  CategoryItem(this.category, this.key);

  @override
  GlobalKey? getKey() => key;

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      child: Text(
        category,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  @override
  Widget? buildSubtitle(BuildContext context) => null;
}

class ProductItem implements ProductListItem {
  final String name;
  final String price;

  ProductItem(this.name, this.price);

  @override
  GlobalKey? getKey() => null;

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      width: 88.0,
      height: 64.0,
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return Text(
      price,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}