import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class DashboardService {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com';
  
  // Get Dashboard Data
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final headers = await TokenManager.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: headers,
      );
      
      print('📥 Dashboard response status: ${response.statusCode}');
      print('📄 Dashboard response body: ${response.body}');
      
      if (response.statusCode == 401 || response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Session expired. Please login again.',
          'requiresLogin': true,
        };
      }
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load dashboard data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}

// Dashboard Data Model
class DashboardData {
  final double totalExpense;
  final double budget;
  final double remaining;
  final double usedPercentage;
  final List<RecentTransaction> recentTransactions;

  DashboardData({
    required this.totalExpense,
    required this.budget,
    required this.remaining,
    required this.usedPercentage,
    required this.recentTransactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalExpense: double.parse(json['totalExpense'].toString()),
      budget: double.parse(json['budget'].toString()),
      remaining: double.parse(json['remaining'].toString()),
      usedPercentage: double.parse(json['usedPercentage'].toString()),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
          ?.map((item) => RecentTransaction.fromJson(item))
          .toList() ?? [],
    );
  }

  int get daysLeft {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayOfMonth.difference(now).inDays;
  }
}

// Recent Transaction Model
class RecentTransaction {
  final int id;
  final double amount;
  final String category;
  final String? description;
  final DateTime expenseDate;

  RecentTransaction({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.expenseDate,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      category: json['category'],
      description: json['description'],
      expenseDate: DateTime.parse(json['expense_date']),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDay = DateTime(expenseDate.year, expenseDate.month, expenseDate.day);

    if (expenseDay == today) {
      return 'Today';
    } else if (expenseDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${expenseDate.day}/${expenseDate.month}/${expenseDate.year}';
    }
  }

  String get formattedAmount {
    return '-\$${amount.toStringAsFixed(2)}';
  }
}