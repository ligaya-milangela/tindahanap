import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_service.dart';
import 'stores_list_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your email address';
    } if (!EmailValidator.validate(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    return null;
  }

  void login() async {
    bool success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    // The BuildContext is used across an async gap. Check if the
    // widget is still mounted in the widget tree to make sure that
    // the context is still valid before interacting with it.
    if (mounted) {
      if (success) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(builder: (_) => StoresListScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Email or Password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 48.0, top: 96.0, right: 48.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset('assets/logo.png', scale: 3.0),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Text(
                'Tindahanap',
                style: textTheme.displayLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                spacing: 16.0,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),

                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: passwordValidator,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SignupScreen()
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up!',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // The render overflows when focusing on a text field 
      // because the scaffold's body is resized to make room for
      // the keyboard. Set this to false to prevent the resize.
      resizeToAvoidBottomInset: false,
    );
  }
}
