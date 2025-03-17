/* Authored by: Lurd Synell B. Najarila
Company: ABC Co.
Project: Tindahanap
Feature: [TDHN-001] User Signup
Description: User should be able to register an account using email and password.
*/

// Widget for user sign up form.

import 'package:flutter/material.dart';

class SignupForm extends StatelessWidget {
  final Function(String username, String password, String email) onSubmit;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  
  SignupForm({
    super.key,
    required this.onSubmit
  });

  void _onPressed() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    onSubmit(username, password, email);
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
        child: Column(
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            
            const Text(
              'Join and discover your local sari-sari stores',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 64),
            
            _buildFormField(
              label: 'Username',
              placeholder: 'Enter your username',
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            
            _buildFormField(
              label: 'Email Address',
              placeholder: 'Enter your email',
              controller: _emailController,       
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            _buildFormField(
              label: 'Password',
              placeholder: 'Create a password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            
            _buildFormField(
              label: 'Confirm Password',
              placeholder: 'Confirm your password',
              obscureText: true,
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.blueGrey),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}