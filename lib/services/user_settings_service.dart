import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class UserSettingsService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';

  static Future<Map<String, dynamic>> updateBudget(double budget) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/budget'),
        headers: headers,
        body: jsonEncode({'monthly_budget': budget}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': 'Budget updated successfully'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update budget',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/preferences'),
        headers: headers,
        body: jsonEncode(preferences),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': 'Preferences updated successfully'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update preferences',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
