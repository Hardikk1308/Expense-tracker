import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import '../models/expense_model.dart';
import 'base_api_service.dart';

class ExpenseService {
  // Add Expense
  static Future<Map<String, dynamic>> addExpense({
    required double amount,
    required String category,
    required String description,
    required DateTime expenseDate,
  }) async {
    final result = await BaseApiService.post('/expenses', {
      'amount': amount,
      'category': category,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
    });

    if (result['success']) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Expense added successfully',
        'expense': result['data']['expense'],
      };
    } else {
      return {
        'success': false,
        'message': result['message'],
        'requiresLogin': result['requiresLogin'] ?? false,
      };
    }
  }

  // Get Expenses
  static Future<Map<String, dynamic>> getExpenses() async {
    final result = await BaseApiService.get('/expenses');

    if (result['success']) {
      try {
        final List<dynamic> expensesJson = result['data'];
        final List<Expense> expenses = expensesJson
            .map((json) => Expense.fromJson(json))
            .toList();
        return {
          'success': true,
          'expenses': expenses,
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to parse expenses data',
        };
      }
    } else {
      return {
        'success': false,
        'message': result['message'],
        'requiresLogin': result['requiresLogin'] ?? false,
      };
    }
  }

  // Delete Expense
  static Future<Map<String, dynamic>> deleteExpense(int expenseId) async {
    final result = await BaseApiService.delete('/expenses/$expenseId');

    if (result['success']) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Expense deleted successfully',
      };
    } else {
      return {
        'success': false,
        'message': result['message'],
        'requiresLogin': result['requiresLogin'] ?? false,
      };
    }
  }

  // Update Expense
  static Future<Map<String, dynamic>> updateExpense({
    required int expenseId,
    double? amount,
    String? category,
    String? description,
    DateTime? expenseDate,
  }) async {
    final body = <String, dynamic>{};
    
    if (amount != null) body['amount'] = amount;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (expenseDate != null) body['expense_date'] = expenseDate.toIso8601String();

    final result = await BaseApiService.put('/expenses/$expenseId', body);

    if (result['success']) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Expense updated successfully',
        'expense': result['data']['expense'],
      };
    } else {
      return {
        'success': false,
        'message': result['message'],
        'requiresLogin': result['requiresLogin'] ?? false,
      };
    }
  }
}