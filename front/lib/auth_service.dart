import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://127.0.0.1:8000/api"));

  Future<bool> signup(String username, String password) async {
    final response = await _dio.post('/signup/', data: {
      "username": username,
      "password": password,
    });
    return response.statusCode == 201;
  }

  Future<bool> login(String username, String password) async {
    final response = await _dio.post('/login/', data: {
      "username": username,
      "password": password,
    });
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response.data["access"]);
      return true;
    }
    return false;
  }
}