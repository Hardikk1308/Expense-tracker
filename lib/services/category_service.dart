import '../models/category_model.dart';
import 'base_api_service.dart';

class CategoryService {
  static Future<Map<String, dynamic>> getCategories() async {
    final result = await BaseApiService.get('/categories');
    if (result['success']) {
      try {
        final List<dynamic> data = result['data'];
        final categories = data.map((json) => Category.fromJson(json)).toList();
        return {'success': true, 'categories': categories};
      } catch (e) {
        return {'success': false, 'message': 'Failed to parse categories'};
      }
    }
    return {'success': false, 'message': result['message']};
  }

  static Future<Map<String, dynamic>> addCategory(String name, String icon, String color) async {
    final result = await BaseApiService.post('/categories', {
      'name': name,
      'icon_name': icon,
      'color_hex': color,
    });
    if (result['success']) {
      return {'success': true, 'category': Category.fromJson(result['data'])};
    }
    return {'success': false, 'message': result['message']};
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    final result = await BaseApiService.delete('/categories/$id');
    return {'success': result['success'], 'message': result['message']};
  }
}
