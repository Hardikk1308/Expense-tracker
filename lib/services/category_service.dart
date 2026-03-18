import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final int? color;

  CategoryModel({required this.id, required this.name, this.icon, this.color});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'] != null
          ? int.tryParse(json['color'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'color': color};
  }
}

class CategoryService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';

  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        final categories = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return {'success': true, 'data': categories};
      } else {
        return {'success': false, 'message': 'Failed to fetch categories'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> addCategory(
    String name,
    String icon,
    int color,
  ) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/categories'),
        headers: headers,
        body: jsonEncode({'name': name, 'icon': icon, 'color': color}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': CategoryModel.fromJson(jsonDecode(response.body)),
        };
      } else {
        return {'success': false, 'message': 'Failed to add category'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateCategory(
    int id,
    String name,
    String icon,
    int color,
  ) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/categories/$id'),
        headers: headers,
        body: jsonEncode({'name': name, 'icon': icon, 'color': color}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': CategoryModel.fromJson(jsonDecode(response.body)),
        };
      } else {
        return {'success': false, 'message': 'Failed to update category'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/categories/$id'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'message': 'Category deleted'};
      } else {
        return {'success': false, 'message': 'Failed to delete category'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
