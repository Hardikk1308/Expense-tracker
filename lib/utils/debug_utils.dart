import 'dart:convert';
import 'package:http/http.dart' as http;

class DebugUtils {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';
  
  // Test basic connectivity to the API
  static Future<void> testApiConnectivity() async {
    print('🌐 DEBUG: Testing API connectivity...');
    print('🔗 DEBUG: Base URL: $baseUrl');
    
    try {
      // Test basic connectivity
      final response = await http.get(
        Uri.parse('$baseUrl/auth/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      print('📊 DEBUG: Test response status: ${response.statusCode}');
      print('📄 DEBUG: Test response body: ${response.body}');
      
    } catch (e) {
      print('💥 DEBUG: API connectivity test failed: $e');
      print('💥 DEBUG: Error type: ${e.runtimeType}');
    }
  }
  
  // Test login endpoint specifically
  static Future<void> testLoginEndpoint(String email, String password) async {
    print('🔐 DEBUG: Testing login endpoint...');
    print('🔗 DEBUG: Login URL: $baseUrl/auth/login');
    
    try {
      final requestBody = {
        'email': email,
        'password': password,
      };
      
      print('📤 DEBUG: Request body: $requestBody');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 15));
      
      print('📊 DEBUG: Login response status: ${response.statusCode}');
      print('📄 DEBUG: Login response body: ${response.body}');
      print('📋 DEBUG: Login response headers: ${response.headers}');
      
    } catch (e) {
      print('💥 DEBUG: Login endpoint test failed: $e');
      print('💥 DEBUG: Error type: ${e.runtimeType}');
    }
  }
  
  // Print all stored data for debugging
  static Future<void> printStoredData() async {
    print('💾 DEBUG: Checking stored data...');
    
    try {
      // This would require importing shared_preferences
      // For now, just print that we're checking
      print('🔍 DEBUG: Use TokenManager.getToken() to check stored token');
      print('🔍 DEBUG: Use TokenManager.getUserData() to check user data');
      
    } catch (e) {
      print('💥 DEBUG: Error checking stored data: $e');
    }
  }
}