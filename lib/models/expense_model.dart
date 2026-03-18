class Expense {
  final int id;
  final double amount;
  final String category;
  final String? description;
  final DateTime expenseDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.expenseDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      category: json['category'],
      description: json['description'],
      expenseDate: DateTime.parse(json['expense_date']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get formattedAmount {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String get formattedAmountWithSign {
    return '-₹${amount.toStringAsFixed(2)}';
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

  String get displayTitle {
    return description?.isNotEmpty == true ? description! : category;
  }

  // Category icon mapping
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        return '🍽️';
      case 'transport':
      case 'transportation':
      case 'trip':
        return '🚗';
      case 'bills':
      case 'bills & utilities':
        return '📄';
      case 'shopping':
        return '🛍️';
      case 'healthcare':
        return '🏥';
      case 'entertainment':
        return '🎬';
      case 'coffee':
      case 'coffee & drinks':
        return '☕';
      case 'gym':
      case 'fitness':
        return '💪';
      case 'pet':
      case 'pets':
        return '🐕';
      default:
        return '💰';
    }
  }

  // Copy with method for updates
  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? description,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}