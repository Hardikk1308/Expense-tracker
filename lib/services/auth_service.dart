import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class AuthService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';

  //============================LOGIN=============================
  static Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔐 AuthService.login() called');
    print('📧 Email: $email');
    print('🔗 URL: $baseUrl/api/auth/login');
    
    try {
      final requestBody = {
        'email': email,
        'password': password,
      };
      
      print('📤 Request body: $requestBody');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final data = jsonDecode(response.body);
      print('📊 Parsed data: $data');
      
      if (response.statusCode == 200) {
        print('✅ Login successful');
        
        // Save token and user data
        if (data['token'] != null) {
          print('💾 Saving token: ${data['token'].substring(0, 20)}...');
          await TokenManager.saveToken(data['token']);
          print('✅ Token saved successfully');
        } else {
          print('❌ No token in response');
        }
        
        return {
          'success': true,
          'message': data['message'],
          'token': data['token'],
        };
      } else {
        print('❌ Login failed with status: ${response.statusCode}');
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('💥 Login error: $e');
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
        Uri.parse('$baseUrl/api/auth/register'),
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
        Uri.parse('$baseUrl/api/auth/userinfo'),
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