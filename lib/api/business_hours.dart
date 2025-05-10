import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BusinessHours {
  final String businessHoursId;
  final String openingHours;
  final String closingHours;

  const BusinessHours({
    required this.businessHoursId,
    required this.openingHours,
    required this.closingHours,
  });
}

Future<void> createBusinessHours(BusinessHours businessHours, String storeId) async {
  try {
    await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('businessHours')
      .add({
        'openingHours': businessHours.openingHours,
        'closingHours': businessHours.closingHours,
      });
  } catch (e) {
    debugPrint('Error creating store business hours: $e');
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
        openingHours: doc['openingHours'],
        closingHours: doc['closingHours'],
      ));
    }
  } catch (e) {
    debugPrint('Error getting store business hours: $e');
    rethrow;
  }
  
  return businessHours;
}