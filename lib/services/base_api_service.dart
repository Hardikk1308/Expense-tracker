import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

import '../core/api_config.dart';

class BaseApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  // Handle API response and check for authentication errors
  static Map<String, dynamic> handleResponse(http.Response response) {
    print('📥 BaseApiService.handleResponse() called');
    print('📊 Status code: ${response.statusCode}');
    print('📄 Response body: ${response.body}');
    
    final data = jsonDecode(response.body);
    print('📊 Parsed data: $data');
    
    // Check for authentication errors
    if (response.statusCode == 401 || response.statusCode == 403) {
      print('🚫 Authentication error detected');
      return {
        'success': false,
        'message': 'Session expired. Please login again.',
        'requiresLogin': true,
      };
    }
    
    final result = {
      'success': response.statusCode >= 200 && response.statusCode < 300,
      'data': data,
      'statusCode': response.statusCode,
      'message': data['message'] ?? (response.statusCode >= 200 && response.statusCode < 300 
          ? 'Success' 
          : 'Request failed'),
    };
    
    print('📤 Returning result: $result');
    return result;
  }
  
  // Generic GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  // Generic POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  // Generic PUT request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}