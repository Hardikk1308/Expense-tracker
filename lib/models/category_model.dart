import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String iconName;
  final String colorHex;
  final int? userId;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      iconName: json['icon_name'] ?? json['icon'] ?? 'category',
      colorHex: json['color_hex'] ?? json['color'] ?? '#4F46E5',
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
      'user_id': userId,
    };
  }

  Color get color {
    final hexString = colorHex.replaceAll('#', '');
    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16));
    }
    return const Color(0xFF4F46E5);
  }

  IconData get iconData {
    switch (iconName.toLowerCase()) {
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'directions_car':
      case 'transport':
        return Icons.directions_car;
      case 'bolt':
      case 'bills':
        return Icons.bolt;
      case 'shopping_bag':
      case 'shopping':
        return Icons.shopping_bag;
      case 'local_hospital':
      case 'health':
        return Icons.local_hospital;
      case 'movie':
      case 'entertainment':
        return Icons.movie;
      case 'local_cafe':
      case 'coffee':
        return Icons.local_cafe;
      case 'fitness_center':
      case 'gym':
        return Icons.fitness_center;
      case 'pets':
      case 'pet':
        return Icons.pets;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'gift':
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'education':
      case 'school':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
