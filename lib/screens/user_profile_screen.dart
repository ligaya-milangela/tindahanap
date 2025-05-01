import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_settings_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Manage your account settings',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(32.0, 64.0, 32.0, 0.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/a/ACg8ocKkEn4uSpl7y645bVbHFxOR3cpFkgwwYSc1FXbycdjpUU1KyA=s192-c-br100-rg-mo',
                    ),
                    radius: 70.0,
                  ),
                  const SizedBox(height: 16),

                  // First Name + Last Name with "Hi!"
                  Text(
                    'Hi, $firstName $lastName!',
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  // Email
                  Text(
                    email,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Account Settings Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      textStyle: textTheme.bodyLarge,
                      minimumSize: const Size.fromHeight(50.0),
                    ),
                    child: const Text('Account Settings'),
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme.onTertiary,
                      backgroundColor: colorScheme.tertiary,
                      textStyle: textTheme.bodyLarge,
                      minimumSize: const Size.fromHeight(50.0),
                    ),
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
}
