import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class AuthService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com/auth';

  //============================LOGIN=============================
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save token and user data
        await TokenManager.saveToken(data['token']);
        
        return {
          'success': true,
          'message': data['message'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // =============================REGISTRATION=============================
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        // Save user data for future use
        if (data['user'] != null) {
          await TokenManager.saveUserData(
            userId: data['user']['id'].toString(),
            username: data['user']['username'],
            email: data['user']['email'],
          );
        }
        
        return {
          'success': true,
          'message': data['message'],
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get user info using stored token
  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get user info',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    await TokenManager.clearAll();
  }
}