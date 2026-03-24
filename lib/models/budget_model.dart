class BudgetModel {
  final int id;
  final String category;
  final double amount;
  final int month;
  final int year;

  BudgetModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      category: json['category'],
      amount: double.parse(json['amount'].toString()),
      month: json['month'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }
}
