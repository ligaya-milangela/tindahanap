import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  bool isSending = false;
  bool isExpanded = false; // For ExpansionPanel

  Future<void> sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'email': emailController.text.trim(),
          'feedback': feedbackController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback sent successfully!')),
        );

        emailController.clear();
        feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending feedback: $e')),
        );
      } finally {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        color: colorScheme.primary,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              width: double.infinity,
              height: 116.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help & Support',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Contact us or send your feedback',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Info
                      const Text(
                        'Contact Us:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.email_outlined),
                          SizedBox(width: 8),
                          Text('tindahanap@gmail.com'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // About Expansion
                      ExpansionPanelList(
                        expandedHeaderPadding: EdgeInsets.zero,
                        expansionCallback: (int index, bool isOpen) {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        elevation: 1,
                        children: [
                          ExpansionPanel(
                            isExpanded: isExpanded,
                            headerBuilder: (context, isOpen) {
                              return const ListTile(
                                title: Text('About Tindahanap App'),
                              );
                            },
                            body: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Tindahanap is your go-to app for finding nearby sari-sari stores. '
                                'Discover store locations and browse their product lists — all in one place!',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Feedback Section
                      const Text(
                        'Send Feedback:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Your Email',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(color: colorScheme.onSurface),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: feedbackController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Your Feedback',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(color: colorScheme.onSurface),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your feedback';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity, // Full width
                              height: 48.0, // Fixed height
                              child: ElevatedButton(
                                onPressed: isSending ? null : sendFeedback,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                ),
                                child: isSending
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Send Feedback'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Back Button
                            SizedBox(
                              width: double.infinity,
                              height: 48.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                                child: const Text('Back'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
