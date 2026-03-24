class Budget {
  final int id;
  final double monthlyLimit;
  final double currentSpent;
  final int month;
  final int year;

  Budget({
    required this.id,
    required this.monthlyLimit,
    required this.currentSpent,
    required this.month,
    required this.year,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      monthlyLimit: double.parse(json['monthly_limit'].toString()),
      currentSpent: double.parse((json['current_spent'] ?? 0).toString()),
      month: json['month'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthly_limit': monthlyLimit,
      'current_spent': currentSpent,
      'month': month,
      'year': year,
    };
  }

  double get remaining => monthlyLimit - currentSpent;
  double get progress => monthlyLimit == 0 ? 0 : (currentSpent / monthlyLimit).clamp(0, 1.0);
}
