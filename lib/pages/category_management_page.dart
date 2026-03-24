import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../models/category_model.dart';
import '../widgets/custom_card.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'category';
  String _selectedColor = '#4F46E5';

  final List<Map<String, dynamic>> _iconList = [
    {'name': 'restaurant', 'icon': Icons.restaurant},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'bolt', 'icon': Icons.bolt},
    {'name': 'shopping_bag', 'icon': Icons.shopping_bag},
    {'name': 'local_hospital', 'icon': Icons.local_hospital},
    {'name': 'movie', 'icon': Icons.movie},
    {'name': 'local_cafe', 'icon': Icons.local_cafe},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'work', 'icon': Icons.work},
  ];

  final List<String> _colorPalette = [
    '#4F46E5', '#EF4444', '#10B981', '#F59E0B', '#3B82F6', '#8B5CF6', '#EC4899', '#06B6D4'
  ];

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 32, left: 24, right: 24),
          decoration: BoxDecoration(color: AppColors.getSurface(context), borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Category', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 32),
              _buildSectionLabel('CATEGORY NAME'),
              TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'e.g. Subscriptions')),
              const SizedBox(height: 24),
              _buildSectionLabel('CHOOSE ICON'),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _iconList.length,
                  itemBuilder: (context, i) {
                    final item = _iconList[i];
                    final isSelected = _selectedIcon == item['name'];
                    return GestureDetector(
                      onTap: () => setModalState(() => _selectedIcon = item['name']),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.getBackground(context),
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected ? Border.all(color: AppColors.primaryLight, width: 2) : null,
                        ),
                        child: Icon(item['icon'], color: isSelected ? Colors.white : AppColors.getTextSecondary(context), size: 22),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionLabel('CHOOSE COLOR'),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _colorPalette.length,
                  itemBuilder: (context, i) {
                    final hex = _colorPalette[i];
                    final isSelected = _selectedColor == hex;
                    return GestureDetector(
                      onTap: () => setModalState(() => _selectedColor = hex),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 48,
                        decoration: BoxDecoration(
                          color: Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16)),
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: AppColors.getTextPrimary(context), width: 4) : null,
                          boxShadow: isSelected ? [AppColors.softShadow(context)] : null,
                        ),
                        child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 24) : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty) {
                      await context.read<ExpenseProvider>().addCategory(_nameController.text, _selectedIcon, _selectedColor);
                      _nameController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Category'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: const Text('Categories')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.categories.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(AppColors.paddingLarge),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: CustomCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      _buildCatIcon(cat),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(cat.name, style: Theme.of(context).textTheme.titleMedium),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error, size: 22),
                        onPressed: () => _confirmDelete(cat),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildCatIcon(Category cat) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cat.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(cat.iconData, color: cat.color, size: 24),
    );
  }

  void _confirmDelete(Category cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${cat.name}"?', style: Theme.of(context).textTheme.titleMedium),
        content: const Text('Expenses in this category will be preserved but lose their icon/color association.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await context.read<ExpenseProvider>().deleteCategory(cat.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: AppColors.getBorder(context)),
          const SizedBox(height: 24),
          Text('Establish your categories.', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
