import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'services/search_service.dart';
import 'widgets/inherited_shared_data.dart';
import 'screens/stores_list_screen.dart';
import 'screens/stores_map_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/user_profile_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Position userLocation;
  int currentPageIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox();
    }

    return SharedData(
      filters: Filters(),
      location: userLocation,
      child: Scaffold(
        body: [
          const StoresListScreen(),
          const StoresMapScreen(),
          const FavoritesScreen(),
          const UserProfileScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store),
              label: 'Stores',
            ),
            const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map',
            ),
            const NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),

        // The render overflows when focusing on a text field 
        // because the scaffold's body is resized to make room for
        // the keyboard. Set this to false to prevent the resize.
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<void> _fetchUserLocation() async {
    try {
      final Position location = await Geolocator.getCurrentPosition();
      setState(() {
        userLocation = location;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }
}