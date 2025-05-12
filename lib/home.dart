import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'models/filters.dart';
import 'screens/favorites_screen.dart';
import 'screens/stores_list_screen.dart';
import 'screens/stores_map_screen.dart';
import 'screens/user_profile_screen.dart';
import 'widgets/inherited_shared_data.dart';

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', scale: 3.0),
              const SizedBox(height: 8.0),

              Text(
                'Tindahanap',
                style: textTheme.displayLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48.0),
              
              const CircularProgressIndicator(),
              const SizedBox(height: 12.0),

              const Text('Logging in...'),
            ],
          ),
        ),
      );
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