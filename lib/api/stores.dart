import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Store{
  final String storeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String blurb;
  final String phoneNumber;
  final String imageUrl;

  const Store({
    required this.storeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.blurb,
    required this.phoneNumber,
    required this.imageUrl,
  });
}

Future<void> createStore(Store store) async {
  try {
    await FirebaseFirestore.instance.collection('stores').add({
      'name': store.name,
      'address': store.address,
      'latitude': store.latitude,
      'longitude': store.longitude,
      'blurb': store.blurb,
      'phoneNumber': store.phoneNumber,
      'imageUrl': store.imageUrl,
    });
  } catch (e) {
    debugPrint('Error creating store: $e');
    rethrow;
  }
}

Future<List<Store>> getStores() async {
  List<Store> stores = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('stores').get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      stores.add(Store(
        storeId: doc.id,
        name: doc['name'],
        address: doc['address'],
        latitude: doc['latitude'],
        longitude: doc['longitude'],
        blurb: doc['blurb'],
        phoneNumber: doc['phoneNumber'],
        imageUrl: doc['imageUrl'],
      ));
    }
  } catch (e) {
    debugPrint('Error getting stores: $e');
    rethrow;
  }
  
  return stores;
}

Future<Store> getStore(String storeId) async {
  Store store;

  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('stores').doc(storeId).get();
    store = Store(
      storeId: doc.id,
      name: doc['name'],
      address: doc['address'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      blurb: doc['blurb'],
      phoneNumber: doc['phoneNumber'],
      imageUrl: doc['imageUrl'],
    );
  } catch (e) {
    debugPrint('Error getting store: $e');
    rethrow;
  }

  return store;
}