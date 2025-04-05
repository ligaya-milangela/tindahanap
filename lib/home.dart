import 'package:flutter/material.dart';
import 'screens/stores_list_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        StoresListScreen(),
        Center(child: Text("Map screen")),
        Center(child: Text("Favorites screen")),
        Center(child: Text("Profile screen")),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
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
    );
  }
}