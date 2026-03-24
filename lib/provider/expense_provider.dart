import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalBalance => _expenses.fold(0, (sum, item) => sum + item.amount);

  double get currentMonthBalance {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.expenseDate.month == now.month && e.expenseDate.year == now.year)
        .fold(0, (sum, item) => sum + item.amount);
  }

  Future<void> fetchExpenses() async {
    _setLoading(true);
    final result = await ExpenseService.getExpenses();
    if (result['success']) {
      _expenses = result['expenses'] as List<Expense>;
      _error = null;
    } else {
      _error = result['message'];
    }
    _setLoading(false);
  }

  Future<bool> addExpense({
    required double amount,
    required String category,
    required String description,
    required DateTime expenseDate,
  }) async {
    _setLoading(true);
    final result = await ExpenseService.addExpense(
      amount: amount,
      category: category,
      description: description,
      expenseDate: expenseDate,
    );
    
    if (result['success']) {
      final newExpense = Expense.fromJson(result['expense']);
      _expenses.insert(0, newExpense);
      _error = null;
      _setLoading(false);
      return true;
    } else {
      _error = result['message'];
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteExpense(int id) async {
    final result = await ExpenseService.deleteExpense(id);
    if (result['success']) {
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } else {
      _error = result['message'];
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
