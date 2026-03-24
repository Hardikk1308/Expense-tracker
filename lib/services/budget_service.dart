import '../models/budget_model.dart';
import 'base_api_service.dart';

class BudgetService {
  static Future<Map<String, dynamic>> getBudget(int month, int year) async {
    final result = await BaseApiService.get('/budgets?month=$month&year=$year');
    if (result['success']) {
      try {
        final budget = Budget.fromJson(result['data']);
        return {'success': true, 'budget': budget};
      } catch (e) {
        return {'success': false, 'message': 'Failed to parse budget'};
      }
    }
    return {'success': false, 'message': result['message']};
  }

  static Future<Map<String, dynamic>> setBudget(double limit, int month, int year) async {
    final result = await BaseApiService.post('/budgets', {
      'monthly_limit': limit,
      'month': month,
      'year': year,
    });
    if (result['success']) {
      return {'success': true, 'budget': Budget.fromJson(result['data'])};
    }
    return {'success': false, 'message': result['message']};
  }
}
