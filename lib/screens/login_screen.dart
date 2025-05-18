import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_service.dart' as auth_service;
import '../home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(36.0, 96.0, 36.0, 0.0),
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
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key),
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

                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        textStyle: textTheme.bodyLarge,
                        minimumSize: const Size.fromHeight(50.0),
                      ),
                      child: Text(
                        'Log In',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
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
      ),
    );
  }

  void login() async {
    try {
      await auth_service.login(_emailController.text, _passwordController.text);
      
      if (!mounted) return;
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Email or Password')),
      );
    }
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
}
