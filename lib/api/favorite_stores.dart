import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_store.dart';

Future<FavoriteStore> createFavoriteStore(String storeId, String userId) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favoriteStores')
      .add({
        'storeId': storeId,
      });
    DocumentSnapshot doc = await docRef.get();
    
    return FavoriteStore(
      favoriteId: doc.id,
      storeId: doc['storeId'],
    );
  } catch (e) {
    print('Error creating user favorite store: $e');
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
    print('Error getting user favorite stores: $e');
    rethrow;
  }
  
  return favoriteStores;
}

Future<void> deleteFavoriteStore(String favoriteStoreId, String userId) async {
  try {
    FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favoriteStores')
      .doc(favoriteStoreId)
      .delete();
  } catch (e) {
    print('Error deleting user favorite store: $e');
    rethrow;
  }
}