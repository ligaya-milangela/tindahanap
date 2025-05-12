class Store{
  String storeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String blurb;
  final String phoneNumber;
  final String imageUrl;

  Store({
    this.storeId = '',
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.blurb,
    required this.phoneNumber,
    required this.imageUrl,
  });
}