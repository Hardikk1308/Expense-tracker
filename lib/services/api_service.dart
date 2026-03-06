import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class ApiService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';
  
  // Generic API call with automatic token handling
  static Future<Map<String, dynamic>> makeRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      // Check if token is expired before making request
      if (await TokenManager.isTokenExpired()) {
        await TokenManager.clearAll();
        return {
          'success': false,
          'message': 'Session expired. Please login again.',
          'needsLogin': true,
        };
      }

      final headers = await TokenManager.getAuthHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final uri = Uri.parse('$baseUrl$endpoint');
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Handle authentication errors
      if (response.statusCode == 401 || response.statusCode == 403) {
        await TokenManager.clearAll();
        return {
          'success': false,
          'message': 'Session expired. Please login again.',
          'needsLogin': true,
        };
      }

      // Parse response
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': data,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Request failed',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Convenience methods
  static Future<Map<String, dynamic>> get(String endpoint) {
    return makeRequest(method: 'GET', endpoint: endpoint);
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) {
    return makeRequest(method: 'POST', endpoint: endpoint, body: body);
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) {
    return makeRequest(method: 'PUT', endpoint: endpoint, body: body);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) {
    return makeRequest(method: 'DELETE', endpoint: endpoint);
  }
}