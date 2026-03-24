import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';
import '../widgets/expense_list_item.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final totalSpent = provider.currentMonthSpent;
          final budget = provider.budget?.monthlyLimit ?? 0;
          final balance = (budget - totalSpent).clamp(0.0, double.infinity);
          final progress = budget > 0 ? (totalSpent / budget).clamp(0.0, 1.0) : 0.0;

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(l10n),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildBudgetCard(totalSpent, balance, progress, l10n),
                        const SizedBox(height: 40),
                        _buildSectionHeader(l10n.translate('recent_transactions').toUpperCase()),
                        const SizedBox(height: 16),
                        if (provider.expenses.isEmpty)
                          _buildEmptyState(l10n)
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.expenses.length,
                            itemBuilder: (context, index) {
                              return ExpenseListItem(
                                expense: provider.expenses[index],
                                onDelete: () => provider.deleteExpense(provider.expenses[index].id),
                              );
                            },
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 40,
      backgroundColor: AppColors.getBackground(context),
      title: Text(l10n.translate('dashboard')),
      floating: true,
      centerTitle: false,
    );
  }

  Widget _buildBudgetCard(double spent, double balance, double progress, AppLocalizations l10n) {
    return CustomCard(
      gradient: AppColors.primaryGradient,
      padding: const EdgeInsets.all(AppColors.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.translate('balance'), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
          const SizedBox(height: 8),
          Text('₹${balance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric(l10n.translate('spent'), '₹${spent.toStringAsFixed(0)}'),
              _buildMetric(l10n.translate('total_budget'), '₹${(spent + balance).toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2));
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.getBorder(context)),
          const SizedBox(height: 16),
          Text(l10n.translate('empty_dashboard'), style: TextStyle(color: AppColors.getTextSecondary(context))),
        ],
      ),
    );
  }
}
