import '../api/business_hours.dart';
import '../models/business_hours.dart';

Future<List<BusinessHours>> getStoreBusinessHours(String storeId) async {
  List<BusinessHours> businessHours = await getBusinessHours(storeId);
  businessHours.sort((a, b) => a.weekday - b.weekday);
  return businessHours;
}

