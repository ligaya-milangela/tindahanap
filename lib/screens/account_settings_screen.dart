import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/password_requirement.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;
  bool _showPasswordCriteria = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Account Settings'),
          backgroundColor: colorScheme.secondaryContainer,
        ),
        body: const Center(child: Text('No user logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        shadowColor: colorScheme.shadow,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 24.0,
            children: [
              Text(
                'Email: ${FirebaseAuth.instance.currentUser?.email ?? 'No email'}',
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        spacing: 16.0,
        children: [
          // Current Password Field
          TextFormField(
            controller: _currentPasswordController,
            decoration: InputDecoration(
              labelText: 'Current Password',
              suffixIcon: IconButton(
                icon: Icon(_isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            obscureText: !_isCurrentPasswordVisible,
            validator: _validateCurrentPassword,
          ),
          
          // New Password Field
          TextFormField(
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              suffixIcon: IconButton(
                icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _isNewPasswordVisible = !_isNewPasswordVisible);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            obscureText: !_isNewPasswordVisible,
            onChanged: _checkPasswordStrength,
            validator: _validateNewPassword,
          ),

          // Display Password Requirements with Green Check and Red X
          if (_showPasswordCriteria)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasswordRequirement(requirement: 'At least 8 characters', isValid: _hasMinLength),
                PasswordRequirement(requirement: 'At least 1 uppercase letter', isValid: _hasUppercase),
                PasswordRequirement(requirement: 'At least 1 lowercase letter', isValid: _hasLowercase),
                PasswordRequirement(requirement: 'At least 1 number', isValid: _hasNumber),
                PasswordRequirement(requirement: 'At least 1 special character', isValid: _hasSpecialChar),
              ],
            ),
          
          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            obscureText: !_isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
          ),

          _isLoading
            ? SizedBox(
                width: double.infinity,
                height: 50.0,
                child: FilledButton(
                  onPressed: () {},
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(color: colorScheme.onPrimary),
                  )
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: 50.0,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  style: FilledButton.styleFrom(
                    textStyle: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Change Password'),
                ),
              ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    try {
      setState(() => _isLoading = true);

      // Reauthenticate user with current password
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // Update the password
      await user.updatePassword(newPassword);

      // Sign out the user to force them to log in again
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        // Redirect to the login screen
        Navigator.pushReplacementNamed(context, '/login');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            (e.code == 'wrong-password') ? 'Your password is incorrect!' : 'Error: ${e.message}'
          )),
        );
      }
    } finally {
      setState(() =>_isLoading = false);
    }
  }

  // Function to check password strength
  void _checkPasswordStrength(String password) {
    setState(() {
      _showPasswordCriteria = password.isNotEmpty;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasMinLength = password.length >= 8;
    });
  }

  // Function to validate the current password
  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your current password';
    }
    return null;
  }

  // Function to validate the new password
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!_hasUppercase || !_hasLowercase || !_hasNumber || !_hasSpecialChar || !_hasMinLength) {
      return 'Password must meet the criteria';
    }
    return null;
  }

  // Function to check if the passwords match
  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
