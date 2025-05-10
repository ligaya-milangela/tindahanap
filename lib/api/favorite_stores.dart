import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoriteStore {
  final String favoriteId;
  final String storeId;

  const FavoriteStore({
    required this.favoriteId,
    required this.storeId,
  });
}

Future<void> createFavoriteStore(FavoriteStore store, String userId) async {
  try {
    await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favoriteStores')
      .add({
        'storeId': store.storeId,
      });
  } catch (e) {
    debugPrint('Error creating user favorite store: $e');
    rethrow;
  }
}

Future<List<FavoriteStore>> getFavoriteStores(String userId) async {
  List<FavoriteStore> favoriteStores = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favoriteStores')
      .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      favoriteStores.add(FavoriteStore(
        favoriteId: doc.id,
        storeId: doc['storeId'],
      ));
    }
  } catch (e) {
    debugPrint('Error getting user favorite stores: $e');
    rethrow;
  }
  
  return favoriteStores;
}