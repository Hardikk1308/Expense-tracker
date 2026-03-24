import 'package:flutter/material.dart';

class Expense {
  final int id;
  final double amount;
  final int? categoryId; // New
  final String category; // Kept for legacy
  final String? categoryName; // From Join
  final String? iconName; // From Join
  final String? colorHex; // From Join
  final String? description;
  final DateTime expenseDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    required this.id,
    required this.amount,
    this.categoryId,
    required this.category,
    this.categoryName,
    this.iconName,
    this.colorHex,
    this.description,
    required this.expenseDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      categoryId: json['category_id'],
      category: json['category_name'] ?? json['category'] ?? 'Others',
      categoryName: json['category_name'],
      iconName: json['icon_name'],
      colorHex: json['color_hex'],
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
      'category_id': categoryId,
      'category': category,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
    };
  }

  IconData get icon => getIconFromText(iconName, category);
  Color get color => getColorFromText(colorHex, category);

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

  // Category icon mapping (returns IconData)
  static IconData getIconFromText(String? iconName, String category) {
    if (iconName != null) {
      switch (iconName.toLowerCase()) {
        case 'restaurant': return Icons.restaurant;
        case 'directions_car': return Icons.directions_car;
        case 'bolt': return Icons.bolt;
        case 'shopping_bag': return Icons.shopping_bag;
        case 'local_hospital': return Icons.local_hospital;
        case 'movie': return Icons.movie;
        case 'local_cafe': return Icons.local_cafe;
        case 'fitness_center': return Icons.fitness_center;
        case 'pets': return Icons.pets;
        case 'home': return Icons.home;
        case 'work': return Icons.work;
        default: return Icons.category;
      }
    }

    switch (category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        return Icons.restaurant;
      case 'transport':
      case 'transportation':
      case 'trip':
        return Icons.directions_car;
      case 'bills':
      case 'bills & utilities':
        return Icons.bolt;
      case 'shopping':
        return Icons.shopping_bag;
      case 'healthcare':
        return Icons.local_hospital;
      case 'entertainment':
        return Icons.movie;
      case 'coffee':
      case 'coffee & drinks':
        return Icons.local_cafe;
      case 'gym':
      case 'fitness':
        return Icons.fitness_center;
      case 'pet':
      case 'pets':
        return Icons.pets;
      default:
        return Icons.category;
    }
  }

  // Category color mapping
  static Color getColorFromText(String? hex, String category) {
    if (hex != null) {
      final hexString = hex.replaceAll('#', '');
      if (hexString.length == 6) {
        return Color(int.parse('FF$hexString', radix: 16));
      }
    }

    switch (category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        return const Color(0xFFF43F5E);
      case 'transport':
      case 'transportation':
      case 'trip':
        return const Color(0xFF8B5CF6);
      case 'bills':
      case 'bills & utilities':
        return const Color(0xFF06B6D4);
      case 'shopping':
        return const Color(0xFFEC4899);
      case 'healthcare':
        return const Color(0xFF22C55E);
      case 'entertainment':
        return const Color(0xFFF97316);
      case 'coffee':
      case 'coffee & drinks':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF64748B);
    }
  }

  Expense copyWith({
    int? id,
    double? amount,
    int? categoryId,
    String? category,
    String? categoryName,
    String? iconName,
    String? colorHex,
    String? description,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}