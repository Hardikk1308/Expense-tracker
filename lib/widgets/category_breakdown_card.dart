import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import '../constants/app_colors.dart';
import 'custom_card.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const CategoryBreakdownCard({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) return const SizedBox.shrink();

    final List<PieChartSectionData> sections = [];
    final List<Widget> legends = [];
    final double grandTotal = categoryTotals.values.reduce((a, b) => a + b);

    categoryTotals.forEach((category, total) {
      final color = Expense.getColorFromText(null, category);
      sections.add(PieChartSectionData(
        color: color,
        value: total,
        title: '',
        radius: 12,
        showTitle: false,
      ));

      legends.add(_buildLegendItem(context, category, total, color, grandTotal));
    });

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SPENDING BREAKDOWN', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
              const Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                flex: 45,
                child: SizedBox(
                  height: 140,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: sections,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 55,
                child: Column(children: legends),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String name, double amount, Color color, double grandTotal) {
    final double percentage = (amount / grandTotal) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1),
                Text('₹${amount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
              ],
            ),
          ),
          Text('${percentage.toInt()}%', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}
