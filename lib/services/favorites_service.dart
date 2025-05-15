import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../api/favorite_stores.dart';
import '../api/stores.dart';
import '../models/favorite_store.dart';
import '../models/store.dart';

Future<FavoriteStore> getFavoriteStore(String storeId) async {
  final User? user = FirebaseAuth.instance.currentUser;
  final List<FavoriteStore> favoriteStores = await getFavoriteStores(user!.uid);

  for (FavoriteStore favoriteStore in favoriteStores) {
    if (favoriteStore.storeId == storeId) {
      return favoriteStore;
    }
  }

  return FavoriteStore(storeId: storeId);
}

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

Future<FavoriteStore> addToUserFavorites(String storeId) async {
  final User? user = FirebaseAuth.instance.currentUser;
  final FavoriteStore favoriteStore = await createFavoriteStore(storeId, user!.uid);
  return favoriteStore;
}

Future<void> removeFromUserFavorites(String favoriteStoreId) async {
  final User? user = FirebaseAuth.instance.currentUser;
  deleteFavoriteStore(favoriteStoreId, user!.uid);
}