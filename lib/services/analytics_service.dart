import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class AnalyticsService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';

  static Future<Map<String, dynamic>> getCategoryBreakdown({
    String? month,
    String? year,
  }) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      String url = '$baseUrl/api/analytics/category-breakdown';

      if (month != null && year != null) {
        url += '?month=$month&year=$year';
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch category breakdown',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getSpendingTrends() async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/analytics/trends'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to fetch spending trends'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
