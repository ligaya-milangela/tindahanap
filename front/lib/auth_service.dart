import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late final Dio _dio;

  AuthService({String? baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? "http://127.0.0.1:8000/api/", // Default to localhost
    ));
  }

  Future<bool> signup(String firstName, String lastName, String email, String password, String confirmPassword) async {
    try {
      final response = await _dio.post('signup/', data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,  // Send to backend
      });

      print("Signup Response: ${response.data}");
      return response.statusCode == 201;
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('login/', data: {
        "email": email,
        "password": password,
      });

      print("Login Response: ${response.data}");

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["access"]);
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }
}
