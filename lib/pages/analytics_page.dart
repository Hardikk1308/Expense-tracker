import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../models/expense_model.dart';
import '../widgets/custom_card.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ExpenseProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: const Text('Analytics')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.expenses.isEmpty) return _buildEmptyState();

          final categoryTotals = _calculateCategoryTotals(provider);
          final weeklyData = _calculateWeeklySpending(provider.expenses);
          final totalMonthly = provider.currentMonthSpent;
          final dailyAvg = totalMonthly / DateTime.now().day;

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppColors.paddingLarge),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummarySection(totalMonthly, dailyAvg),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Weekly Expenses'),
                  const SizedBox(height: 16),
                  _buildWeeklyChart(weeklyData),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Spend by Category'),
                  const SizedBox(height: 16),
                  _buildCategoryDonutChart(categoryTotals),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Insights'),
                  const SizedBox(height: 16),
                  _buildInsightsCard(categoryTotals),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(double total, double avg) {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            color: AppColors.primary.withOpacity(0.05),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MONTH TOTAL',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY AVG',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${avg.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium);
  }

  Map<String, double> _calculateCategoryTotals(ExpenseProvider provider) {
    final totals = <String, double>{};
    for (var exp in provider.expenses) {
      totals[exp.category] = (totals[exp.category] ?? 0) + exp.amount;
    }
    return totals;
  }

  List<double> _calculateWeeklySpending(List<Expense> expenses) {
    final now = DateTime.now();
    final weekly = List.filled(7, 0.0);
    for (var exp in expenses) {
      final diff = now.difference(exp.expenseDate).inDays;
      if (diff >= 0 && diff < 7) weekly[6 - diff] += exp.amount;
    }
    return weekly;
  }

  Widget _buildWeeklyChart(List<double> data) {
    return CustomCard(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
            100,
            double.infinity,
          ),
          barGroups: List.generate(
            7,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i],
                  color: AppColors.primary,
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: data.reduce((a, b) => a > b ? a : b) * 1.2,
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, m) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][v.toInt() % 7],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildCategoryDonutChart(Map<String, double> totals) {
    final total = totals.values.reduce((a, b) => a + b);
    return CustomCard(
      height: 250,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: totals.entries.map((e) {
                  return PieChartSectionData(
                    color: _getCategoryColor(e.key),
                    value: e.value,
                    title: '',
                    radius: 12,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: ListView(
              shrinkWrap: true,
              children: totals.entries
                  .map((e) => _buildLegendItem(e.key, e.value, total))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name, double value, double total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getCategoryColor(name),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
            ),
          ),
          Text(
            '${(value / total * 100).toInt()}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(Map<String, double> totals) {
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final highest = sorted.first;

    return CustomCard(
      color: Colors.amber.withOpacity(0.05),
      border: Border.all(color: Colors.amber.withOpacity(0.2), width: 1),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending Insight',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'You spent the most on "${highest.key}" this month. Consider tracking this more closely.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String name) {
    try {
      final cat = context.read<ExpenseProvider>().categories.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
      return cat.color;
    } catch (_) {
      return Expense.getColorFromText(null, name);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_mosaic_outlined,
            size: 80,
            color: AppColors.getBorder(context),
          ),
          const SizedBox(height: 24),
          Text(
            'No data to analyze.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
