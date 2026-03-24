import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../services/expense_service.dart';
import '../services/category_service.dart';
import '../services/budget_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  Budget? _currentBudget;
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  Budget? get budget => _currentBudget;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalSpent => _expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get currentMonthSpent {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.expenseDate.month == now.month && e.expenseDate.year == now.year)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // --- Initialization ---

  Future<void> initialize() async {
    _setLoading(true);
    await Future.wait([
      fetchExpenses(),
      fetchCategories(),
      fetchBudget(),
    ]);
    _setLoading(false);
  }

  // --- Expenses ---

  Future<void> fetchExpenses() async {
    final result = await ExpenseService.getExpenses();
    if (result['success']) {
      _expenses = result['expenses'] as List<Expense>;
      _error = null;
    } else {
      _error = result['message'];
    }
    notifyListeners();
  }

  Future<bool> addExpense({
    required double amount,
    required String category,
    int? categoryId,
    required String description,
    required DateTime expenseDate,
  }) async {
    final result = await ExpenseService.addExpense(
      amount: amount,
      category: category,
      categoryId: categoryId,
      description: description,
      expenseDate: expenseDate,
    );
    
    if (result['success']) {
      final newExpense = Expense.fromJson(result['expense']);
      _expenses.insert(0, newExpense);
      await fetchBudget(); // Update budget spent
      notifyListeners();
      return true;
    }
    _error = result['message'];
    return false;
  }

  Future<bool> deleteExpense(int id) async {
    final result = await ExpenseService.deleteExpense(id);
    if (result['success']) {
      _expenses.removeWhere((e) => e.id == id);
      await fetchBudget(); // Update budget spent
      notifyListeners();
      return true;
    }
    _error = result['message'];
    return false;
  }

  // --- Categories ---

  Future<void> fetchCategories() async {
    final result = await CategoryService.getCategories();
    if (result['success']) {
      _categories = result['categories'];
    }
    notifyListeners();
  }

  Future<bool> addCategory(String name, String icon, String color) async {
    final result = await CategoryService.addCategory(name, icon, color);
    if (result['success']) {
      _categories.add(result['category']);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteCategory(int id) async {
    final result = await CategoryService.deleteCategory(id);
    if (result['success']) {
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- Budget ---

  Future<void> fetchBudget() async {
    final now = DateTime.now();
    final result = await BudgetService.getBudget(now.month, now.year);
    if (result['success']) {
      _currentBudget = result['budget'];
    }
    notifyListeners();
  }

  Future<bool> setMonthlyBudget(double limit) async {
    final now = DateTime.now();
    final result = await BudgetService.setBudget(limit, now.month, now.year);
    if (result['success']) {
      _currentBudget = result['budget'];
      notifyListeners();
      return true;
    }
    return false;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
