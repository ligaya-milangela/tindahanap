import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.1.109:8000/api/"));

  // ignore: non_constant_identifier_names
  Future<bool> signup(String username, String password, String email, String text, String Text) async {
    try {
      final response = await _dio.post('signup/', data: {
        "username": username,
        "password": password,
        "email" : email,
      });

      print("Signup Response: ${response.data}");

      return response.statusCode == 201;
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post('login/', data: {
        "username": username,
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
