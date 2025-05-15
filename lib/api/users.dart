import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

Future<void> createUser(TindahanapUser user) async {
  try {
    // Create user in Firebase Authentication
    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    
    // Store user details in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error creating user: $e');
    rethrow;
  }
}

Future<void> patchUserPassword(String currentPassword, String newPassword) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final AuthCredential authCredential = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
    await user.reauthenticateWithCredential(authCredential); // Reauthenticate user with current password
    await user.updatePassword(newPassword); // Update the password
    await FirebaseAuth.instance.signOut(); // Sign out the user to force them to log in again
  } catch (e) {
    print('Error patching user password: $e');
    rethrow;
  }
}