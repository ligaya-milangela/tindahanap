import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business_hours.dart';

Future<void> createBusinessHours(BusinessHours businessHours, String storeId) async {
  try {
    await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('businessHours')
      .add({
        'weekday': businessHours.weekday,
        'openingHour': businessHours.openingHour,
        'openingMinute': businessHours.openingMinute,
        'closingHour': businessHours.closingHour,
        'closingMinute': businessHours.closingMinute,
      });
  } catch (e) {
    print('Error creating store business hours: $e');
    rethrow;
  }
}

Future<List<BusinessHours>> getBusinessHours(String storeId) async {
  List<BusinessHours> businessHours = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('businessHours')
      .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      businessHours.add(BusinessHours(
        businessHoursId: doc.id,
        weekday: doc['weekday'],
        openingHour: doc['openingHour'],
        openingMinute: doc['openingMinute'],
        closingHour: doc['closingHour'],
        closingMinute: doc['closingMinute'],
      ));
    }
  } catch (e) {
    print('Error getting store business hours: $e');
    rethrow;
  }
  
  return businessHours;
}