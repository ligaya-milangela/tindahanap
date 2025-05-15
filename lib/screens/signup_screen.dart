import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_service.dart' as auth_service;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;
  bool _showPasswordCriteria = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(36.0, 24.0, 36.0, 0.0),
        children: [
          Text(
            'Sign Up',
            style: textTheme.displayMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 48.0),
            child: Text(
              'Join and discover your local Sari-sari Stores!',
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),

          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: firstNameValidator,
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: lastNameValidator,
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _passwordController,
                  onChanged: _checkPasswordStrength,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _passwordVisible = !_passwordVisible);
                      },
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: !_passwordVisible,
                  validator: passwordValidator,
                ),

                // Password requirements (only show when user starts typing)
                if (_showPasswordCriteria) ...[
                  const SizedBox(height: 4),
                  _buildPasswordRequirement(context, 'At least 8 characters', _hasMinLength),
                  _buildPasswordRequirement(context, 'At least 1 uppercase letter', _hasUppercase),
                  _buildPasswordRequirement(context, 'At least 1 number', _hasNumber),
                  _buildPasswordRequirement(context, 'At least 1 special character', _hasSpecialChar),
                ],
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                      },
                      icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: !_confirmPasswordVisible,
                  validator: confirmPasswordValidator,
                ),
                const SizedBox(height: 16.0),

                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signup();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    textStyle: textTheme.bodyLarge,
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  child: Text(
                    'Create Account',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(BuildContext context, String text, bool fulfilled) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Row(
      spacing: 4.0,
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled ? Colors.green : colorScheme.error,
          size: 12.0,
        ),
        
        Text(
          text,
          style: textTheme.labelMedium?.copyWith(
            color: fulfilled ? colorScheme.onSurfaceVariant : colorScheme.error,
          ),
        ),
      ],
    );
  }

  void signup() async {
    try {
      await auth_service.signup({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Failed. Please try again.')),
      );
    }
  }

  String? firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your first name';
    }
    return null;
  }

  String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your last name';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an email address';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a password';
    }
    if (!_hasMinLength ||
        !_hasLowercase ||
        !_hasUppercase ||
        !_hasNumber ||
        !_hasSpecialChar) {
      return 'Password does not meet all requirements';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Re-enter your password';
    }
    if (value != _passwordController.text) {
      return 'Password must be same as above';
    }
    return null;
  }

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
}
