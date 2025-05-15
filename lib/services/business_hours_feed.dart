import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business_hours.dart';
import 'dart:math';

final List<BusinessHours> sampleBusinessHoursTemplate = [
  BusinessHours(weekday: 1, openingHour: 9, openingMinute: 0, closingHour: 18, closingMinute: 0),
  BusinessHours(weekday: 2, openingHour: 9, openingMinute: 0, closingHour: 18, closingMinute: 0),
  BusinessHours(weekday: 3, openingHour: 9, openingMinute: 0, closingHour: 18, closingMinute: 0),
  BusinessHours(weekday: 4, openingHour: 9, openingMinute: 0, closingHour: 18, closingMinute: 0),
  BusinessHours(weekday: 5, openingHour: 9, openingMinute: 0, closingHour: 18, closingMinute: 0),
  BusinessHours(weekday: 6, openingHour: 10, openingMinute: 0, closingHour: 16, closingMinute: 0),
  BusinessHours(weekday: 7, openingHour: 0, openingMinute: 0, closingHour: 0, closingMinute: 0), // Closed Sunday
];

List<BusinessHours> generateRandomBusinessHours() {
  final random = Random();
  return sampleBusinessHoursTemplate.map((bh) {
    int openHour = (bh.openingHour + random.nextInt(3) - 1).clamp(0, 23);
    int closeHour = (bh.closingHour + random.nextInt(3) - 1).clamp(0, 23);

    if (bh.openingHour == 0 && bh.closingHour == 0) {
      return bh;
    }

    if (closeHour <= openHour) closeHour = (openHour + 8).clamp(0, 23);

    return BusinessHours(
      weekday: bh.weekday,
      openingHour: openHour,
      openingMinute: bh.openingMinute,
      closingHour: closeHour,
      closingMinute: bh.closingMinute,
    );
  }).toList();
}

Future<void> seedBusinessHoursForAllStores() async {
  try {
    final storesSnapshot = await FirebaseFirestore.instance.collection('stores').get();

    for (final storeDoc in storesSnapshot.docs) {
      final storeId = storeDoc.id;

      // Generate random business hours for this store
      final businessHoursList = generateRandomBusinessHours();

      final batch = FirebaseFirestore.instance.batch();

      for (var bh in businessHoursList) {
        final newDocRef = FirebaseFirestore.instance
            .collection('stores')
            .doc(storeId)
            .collection('businessHours')
            .doc();

        batch.set(newDocRef, {
          'weekday': bh.weekday,
          'openingHour': bh.openingHour,
          'openingMinute': bh.openingMinute,
          'closingHour': bh.closingHour,
          'closingMinute': bh.closingMinute,
        });
      }

      await batch.commit();

      print('Added business hours for store $storeId');
    }
  } catch (e) {
    print('Error seeding business hours: $e');
  }
}
