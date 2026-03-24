import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../models/category_model.dart';
import '../widgets/custom_card.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final VoidCallback? onFinished;
  const AddExpensePage({super.key, this.onFinished});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ExpenseProvider>();
    if (provider.categories.isNotEmpty) _selectedCategory = provider.categories.first;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0 || _selectedCategory == null) return;

    setState(() => _isLoading = true);
    final success = await context.read<ExpenseProvider>().addExpense(
      amount: amount,
      category: _selectedCategory!.name,
      categoryId: _selectedCategory!.id,
      description: _descriptionController.text,
      expenseDate: _selectedDate,
    );
    setState(() => _isLoading = false);

    if (success && widget.onFinished != null) widget.onFinished!();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: Text(l10n.translate('add_expense'))),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppColors.paddingLarge),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountInput(l10n),
                const SizedBox(height: 48),
                _buildSectionLabel(l10n.translate('description').toUpperCase()),
                TextField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences, // Proper casing
                  decoration: const InputDecoration(hintText: 'e.g. Dinner with friends'),
                ),
                const SizedBox(height: 32),
                _buildSectionLabel(l10n.translate('category').toUpperCase()),
                _buildCategoryGrid(provider.categories),
                const SizedBox(height: 32),
                _buildSectionLabel(l10n.translate('date').toUpperCase()),
                _buildDatePicker(),
                const SizedBox(height: 48),
                _buildSubmitButton(l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountInput(AppLocalizations l10n) {
    return Column(
      children: [
        Text(l10n.translate('amount').toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2)),
        const SizedBox(height: 16),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none, // No capitalization for numbers
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 56),
          decoration: const InputDecoration(prefixText: '₹ ', border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, fillColor: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)));
  }

  Widget _buildCategoryGrid(List<Category> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.1, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategory?.id == cat.id;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: CustomCard(
            padding: EdgeInsets.zero,
            color: isSelected ? cat.color.withOpacity(0.12) : AppColors.getSurface(context),
            border: Border.all(color: isSelected ? cat.color : AppColors.getBorder(context), width: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat.iconData, color: isSelected ? cat.color : AppColors.getTextSecondary(context), size: 24),
                const SizedBox(height: 8),
                Text(cat.name, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: isSelected ? cat.color : AppColors.getTextSecondary(context))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: CustomCard(
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 16),
            Text(DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate), style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity, height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(l10n.translate('confirm')),
      ),
    );
  }
}
