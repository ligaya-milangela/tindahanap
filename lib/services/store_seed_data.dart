import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/store.dart';

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
    print('Error creating store: $e');
    rethrow;
  }
}

final List<Store> sampleStores = [
  Store(
    storeId: '',
    name: 'Nory’s Sari-Sari Store',
    address: 'Barangay Concepcion Pequeña, Naga City, Camarines Sur',
    latitude: 13.6218,
    longitude: 123.1856,
    blurb: 'Neighborhood favorite for snacks, canned goods, and daily needs.',
    phoneNumber: '+63 917 123 4567',
    imageUrl: 'https://example.com/images/store1.jpg',
  ),
  Store(
    storeId: '',
    name: 'Aling Pacing’s Tindahan',
    address: 'Zone 1, Barangay Cararayan, Naga City, Camarines Sur',
    latitude: 13.6393,
    longitude: 123.1865,
    blurb: 'Affordable daily essentials with a smile.',
    phoneNumber: '+63 915 234 5678',
    imageUrl: 'https://example.com/images/store2.jpg',
  ),
  Store(
    storeId: '',
    name: 'Mang Tonyo Sari-Sari Store',
    address: 'Barangay Pacol, Naga City, Camarines Sur',
    latitude: 13.6517,
    longitude: 123.2290,
    blurb: 'From soft drinks to pancit canton — suki’s choice!',
    phoneNumber: '+63 927 345 6789',
    imageUrl: 'https://example.com/images/store3.jpg',
  ),
  Store(
    storeId: '',
    name: 'Lola Betty’s Corner',
    address: 'Sitio Ilawod, Barangay San Felipe, Naga City, Camarines Sur',
    latitude: 13.6153,
    longitude: 123.1827,
    blurb: 'Classic kakanin, candies, and everyday finds.',
    phoneNumber: '+63 916 456 7890',
    imageUrl: 'https://example.com/images/store4.jpg',
  ),
  Store(
    storeId: '',
    name: 'Bong’s Sari-Sari Store',
    address: 'Barangay Mabolo, Naga City, Camarines Sur',
    latitude: 13.6182,
    longitude: 123.1882,
    blurb: 'Tambayan ng mga kabataan — ice tubig and chichirya available!',
    phoneNumber: '+63 917 567 8901',
    imageUrl: 'https://example.com/images/store5.jpg',
  ),
  Store(
    storeId: '',
    name: 'Tindahan ni Ate Lita',
    address: 'Barangay Bagumbayan Norte, Naga City, Camarines Sur',
    latitude: 13.6249,
    longitude: 123.1874,
    blurb: 'Trusted corner store since 1995.',
    phoneNumber: '+63 918 678 9012',
    imageUrl: 'https://example.com/images/store6.jpg',
  ),
  Store(
    storeId: '',
    name: 'Totoy’s',
    address: 'Barangay Sabang, Naga City, Camarines Sur',
    latitude: 13.6172,
    longitude: 123.1906,
    blurb: 'Candy, suka, toyo, load — lahat meron dito!',
    phoneNumber: '+63 919 789 0123',
    imageUrl: 'https://example.com/images/store7.jpg',
  ),
  Store(
    storeId: '',
    name: 'Ka Rina Sari-Sari Store',
    address: 'Barangay Abella, Naga City, Camarines Sur',
    latitude: 13.6221,
    longitude: 123.1899,
    blurb: 'Open early morning to late night for your needs.',
    phoneNumber: '+63 920 890 1234',
    imageUrl: 'https://example.com/images/store8.jpg',
  ),
  Store(
    storeId: '',
    name: 'Bahay Kubo Tindahan',
    address: 'Barangay Tinago, Naga City, Camarines Sur',
    latitude: 13.6212,
    longitude: 123.1976,
    blurb: 'Rustic little store with pasalubong items and local finds.',
    phoneNumber: '+63 921 901 2345',
    imageUrl: 'https://example.com/images/store9.jpg',
  ),
  Store(
    storeId: '',
    name: 'Corner Spot',
    address: 'Barangay Peñafrancia, Naga City, Camarines Sur',
    latitude: 13.6189,
    longitude: 123.1944,
    blurb: 'Suki-friendly sari-sari store near the Basilica.',
    phoneNumber: '+63 922 012 3456',
    imageUrl: 'https://example.com/images/store10.jpg',
  ),
];

Future<void> seedStores() async {
  for (final store in sampleStores) {
    await createStore(store);
  }
}
