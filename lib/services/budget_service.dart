import 'base_api_service.dart';

class BudgetService {
  static Future<Map<String, dynamic>> getBudgets({int? month, int? year}) async {
    String query = '';
    if (month != null && year != null) {
      query = '?month=$month&year=$year';
    }
    return await BaseApiService.get('/budgets$query');
  }

  static Future<Map<String, dynamic>> setBudget({
    required String category,
    required double amount,
    int? month,
    int? year,
  }) async {
    return await BaseApiService.post('/budgets', {
      'category': category,
      'amount': amount,
      'month': month,
      'year': year,
    });
  }

  static Future<Map<String, dynamic>> getBudgetProgress({int? month, int? year}) async {
    String query = '';
    if (month != null && year != null) {
      query = '?month=$month&year=$year';
    }
    return await BaseApiService.get('/budgets/progress$query');
  }
}
