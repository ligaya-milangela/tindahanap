import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../api/favorite_stores.dart';
import '../api/stores.dart';

Future<List<Store>> getUserFavoriteStores() async {
  final User? user = FirebaseAuth.instance.currentUser;
  final Position userPosition = await Geolocator.getCurrentPosition();
  final List<FavoriteStore> favoriteStores = await getFavoriteStores(user!.uid);
  List<Store> stores = [];

  for (FavoriteStore favoriteStore in favoriteStores) {
    Store store = await getStore(favoriteStore.storeId);
    stores.add(store);
  }

  // Sort in order of proximity from user
  stores.sort((a, b) {
    double distanceA = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, a.latitude, a.longitude);
    double distanceB = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, b.latitude, b.longitude);
    return distanceA.truncate() - distanceB.truncate();
  });

  return stores;
}