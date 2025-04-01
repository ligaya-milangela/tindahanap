import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'store_map.dart';
import 'store_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String locationText = "Fetching location...";
  double userLat = 0.0;
  double userLon = 0.0;
  List stores = [];

  final LocationService _locationService = LocationService(); // Instantiate the service

  // Get the user's current location
  Future<void> getUserLocation() async {
    try {
      Position position = await _locationService.getUserLocation();
      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
        locationText = "Lat: $userLat, Lon: $userLon";
      });

      fetchNearbyStores(userLat, userLon);
    } catch (e) {
      setState(() {
        locationText = e.toString();
      });
    }
  }

  // Fetch stores based on user's location
  Future<void> fetchNearbyStores(double lat, double lon) async {
    try {
      List fetchedStores = await _locationService.fetchNearbyStores(lat, lon);
      setState(() {
        stores = fetchedStores;
        if (stores.isEmpty) {
          locationText = "No stores found nearby.";
        }
      });
    } catch (e) {
      setState(() {
        stores = [];
        locationText = "Error fetching stores: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to StoreMap page when map icon is tapped
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreMap(
            userLat: userLat,
            userLon: userLon,
            stores: stores,
          ),
        ),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Location and Store Info Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 121, 85, 255),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: getUserLocation,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 196, 178, 252),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          SizedBox(width: 8),
                          Text(locationText, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Store List
                  Container(
                    height: 400,
                    child: stores.isEmpty
                        ? Center(child: Text("No stores available."))
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: stores.length,
                            itemBuilder: (context, index) {
                              return _buildStoreCard(context, stores[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Color.fromARGB(255, 78, 14, 190),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onTabTapped,
        items: [
          _buildNavItem(Icons.store, "Stores"),
          _buildNavItem(Icons.map, "Map"),
          _buildNavItem(Icons.favorite_border, "Favorites"),
          _buildNavItem(Icons.person, "Profile"),
        ],
      ),
    );
  }
Widget _buildStoreCard(BuildContext context, dynamic store) {
  // Retrieve address components, checking if they exist
  String address = store['tags']?['addr:street'] ?? 'No street address';
  String city = store['tags']?['addr:city'] ?? 'No city';
  String postcode = store['tags']?['addr:postcode'] ?? 'No postcode';

  return GestureDetector(
    onTap: () {
      // Navigate to store details page when tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreDetailsPage(store: store),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.store, color: Colors.grey[600]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store['tags']?['name'] ?? 'Unnamed Store',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Showing full address
                Text(
                  '$address, $city, $postcode',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // Custom bottom navigation item
  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
