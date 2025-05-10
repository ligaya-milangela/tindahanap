import 'package:firebase_auth/firebase_auth.dart';
import '../api/users.dart' as user_model;

Future<void> signup(Map<String, dynamic> input) async {
  final user_model.User user = user_model.User(
    firstName: input['firstName'],
    lastName: input['lastName'],
    email: input['email'],
    password: input['password'],
  );
  
  await user_model.createUser(user);
}

Future<void> login(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}