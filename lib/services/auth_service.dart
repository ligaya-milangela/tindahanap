import 'package:firebase_auth/firebase_auth.dart';
import '../api/users.dart';
import '../models/user.dart';

Future<void> signup(Map<String, dynamic> input) async {
  final TindahanapUser user = TindahanapUser(
    firstName: input['firstName'],
    lastName: input['lastName'],
    email: input['email'],
    password: input['password'],
  );
  
  await createUser(user);
}

Future<void> login(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}