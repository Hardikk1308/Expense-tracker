import 'base_api_service.dart';

class DashboardService {
  // Get Dashboard Data
  static Future<Map<String, dynamic>> getDashboardData() async {
    return await BaseApiService.get('/dashboard');
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
    return '-₹${amount.toStringAsFixed(2)}';
  }
}