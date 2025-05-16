import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_settings_screen.dart';
import 'help_support_screen.dart';

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.primaryContainer,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
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
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
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
              child: (isLoading)
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 70.0,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hi, $firstName $lastName!',
                        style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 32),
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
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          textStyle: textTheme.bodyLarge,
                          minimumSize: const Size.fromHeight(50.0),
                        ),
                        child: const Text('Help & Support'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: colorScheme.onTertiaryContainer,
                          backgroundColor: colorScheme.tertiaryContainer,
                          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
          setState(() {
            firstName = email.split('@')[0];
            lastName = '';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          firstName = email.split('@')[0];
          lastName = '';
          isLoading = false;
        });
      }
    }
  }
}
