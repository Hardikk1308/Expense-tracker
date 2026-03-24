import 'base_api_service.dart';

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
  static Future<Map<String, dynamic>> getCategories() async {
    final result = await BaseApiService.get('/categories');
    if (result['success']) {
      final List<dynamic> data = result['data'];
      final categories = data
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      return {'success': true, 'data': categories};
    }
    return result;
  }

  static Future<Map<String, dynamic>> addCategory(
    String name,
    String icon,
    int color,
  ) async {
    final result = await BaseApiService.post('/categories', {
      'name': name,
      'icon': icon,
      'color': color,
    });
    if (result['success']) {
      return {
        'success': true,
        'data': CategoryModel.fromJson(result['data']),
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> updateCategory(
    int id,
    String name,
    String icon,
    int color,
  ) async {
    final result = await BaseApiService.put('/categories/$id', {
      'name': name,
      'icon': icon,
      'color': color,
    });
    if (result['success']) {
      return {
        'success': true,
        'data': CategoryModel.fromJson(result['data']),
      };
    }
    return result;
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    return await BaseApiService.delete('/categories/$id');
  }
}
