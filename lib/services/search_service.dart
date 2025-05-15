import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import 'products_service.dart';
import '../api/stores.dart';
import '../models/filters.dart';
import '../models/product.dart';
import '../models/store.dart';

Future<List<Store>> searchStores(Filters filters) async {
  Position userLocation = await getUserLocation();
  List<Store> stores = await getStores();
  Map<String, List<Product>> productsByStore = {};

  for (Store store in stores) {
    List<Product> products = await getStoreProducts(store.storeId);
    productsByStore[store.storeId] = products;
  }
  
  // Filter by store name
  stores = stores.where((store) => store.name.toLowerCase().contains(filters.query)).toList();

  // Filter by product name and category
  stores = stores.where((store) {
    try {
      for (Product product in productsByStore[store.storeId]!) {
        if (
          product.name.toLowerCase().contains(filters.query) && (
          (filters.selectedFood && product.category == 'Food') ||
          (filters.selectedDrinks && product.category == 'Drinks') ||
          (filters.selectedHygiene && product.category == 'Hygiene') ||
          (filters.selectedMedicine && product.category == 'Medicine') ||
          (filters.selectedHousehold && product.category == 'Household') ||
          (filters.selectedConvenience && product.category == 'Convenience'))
        ) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }).toList();
  
  // // Filter by user proximity
  if (filters.distance < 500) {
    stores = stores.where((store) {
      double distance = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, store.latitude, store.longitude);
      return distance < filters.distance;
    }).toList();
  }

  // Sort in order of proximity from user
  stores.sort((a, b) {
    double distanceA = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, a.latitude, a.longitude);
    double distanceB = Geolocator.distanceBetween(userLocation.latitude, userLocation.longitude, b.latitude, b.longitude);
    return distanceA.truncate() - distanceB.truncate();
  });

  return stores;
}