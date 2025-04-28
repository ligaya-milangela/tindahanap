import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_settings_screen.dart';
import '../theme/app_theme.dart'; // Your theme file

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? '';

      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            firstName = userDoc.data()?['firstName'] ?? '';
            lastName = userDoc.data()?['lastName'] ?? '';
            isLoading = false;
          });
        } else {
          // Fallback if user document doesn't exist
          setState(() {
            firstName = email.split('@')[0];
            lastName = '';
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading user profile: $e');
        setState(() {
          firstName = email.split('@')[0];
          lastName = '';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: colorScheme.primary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            width: double.infinity,
            height: 116.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your account settings',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              width: double.infinity,
              child: ListView(
                padding: const EdgeInsets.only(top: 32.0),
                children: [
                  // Profile Picture
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: const NetworkImage(
                        'https://lh3.googleusercontent.com/a/ACg8ocKkEn4uSpl7y645bVbHFxOR3cpFkgwwYSc1FXbycdjpUU1KyA=s192-c-br100-rg-mo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // First Name + Last Name with "Hi!"
                  Center(
                    child: Text(
                      'Hi! $firstName $lastName',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Center(
                    child: Text(
                      email,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Account Settings Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                      );
                    },
                    child: const Text('Account Settings'),
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color.fromARGB(255, 250, 154, 147),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
