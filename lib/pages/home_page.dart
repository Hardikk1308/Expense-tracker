import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';
import '../widgets/expense_list_item.dart';
import '../services/token_manager.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchData();
  }

  Future<void> _loadUser() async {
    final userData = await TokenManager.getUserData();
    setState(() => username = userData['username']);
  }

  Future<void> _fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().initialize();
    });
  }

  void _showSetBudgetDialog() {
    final controller = TextEditingController(
      text: context.read<ExpenseProvider>().budget?.monthlyLimit.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 32, left: 24, right: 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set Monthly Budget', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text('Enter your limit for ${DateFormat('MMMM').format(DateTime.now())}', 
              style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: Theme.of(context).textTheme.displayMedium,
              decoration: const InputDecoration(prefixText: '₹ ', hintText: '0.00'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  final limit = double.tryParse(controller.text) ?? 0;
                  await context.read<ExpenseProvider>().setMonthlyBudget(limit);
                  Navigator.pop(context);
                },
                child: const Text('Save Budget'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final recentExpenses = provider.expenses.take(5).toList();
          
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildEliteBudgetCard(provider),
                    const SizedBox(height: 40),
                    _buildSectionHeader('Recent Transactions', () {}),
                    const SizedBox(height: 16),
                    if (provider.isLoading && provider.expenses.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
                    else if (provider.expenses.isEmpty)
                      _buildEmptyState()
                    else
                      ...recentExpenses.map((expense) => ExpenseListItem(
                        expense: expense,
                        onDelete: () => provider.deleteExpense(expense.id),
                      )),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hey, ${username ?? "there"}!', style: Theme.of(context).textTheme.displaySmall),
                  Text('Check your finances today.', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person_outline, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEliteBudgetCard(ExpenseProvider provider) {
    final budget = provider.budget?.monthlyLimit ?? 0;
    final spent = provider.currentMonthSpent;
    final remaining = budget - spent;
    final progress = budget == 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);

    return CustomCard(
      gradient: AppColors.primaryGradient,
      padding: const EdgeInsets.all(AppColors.paddingLarge),
      borderRadius: AppColors.borderRadiusLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MONTHLY BUDGET', 
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              GestureDetector(
                onTap: _showSetBudgetDialog,
                child: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('₹${budget.toStringAsFixed(0)}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildSummaryItem('Spent', '₹${spent.toStringAsFixed(0)}'),
              const Spacer(),
              _buildSummaryItem('Balance', '₹${remaining.clamp(0, double.infinity).toStringAsFixed(0)}', isHighlight: true),
            ],
          ),
          const SizedBox(height: 24),
          _buildEliteProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(
          color: Colors.white, 
          fontSize: 18, 
          fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w600,
          letterSpacing: -0.5,
        )),
      ],
    );
  }

  Widget _buildEliteProgressBar(double progress) {
    return Column(
      children: [
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.white24, blurRadius: 8, offset: Offset(0, 2))],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.auto_graph_outlined, size: 64, color: AppColors.getTextTertiary(context).withOpacity(0.5)),
          const SizedBox(height: 24),
          Text('No transactions yet.', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Your budget looks fresh!', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
