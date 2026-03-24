import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/custom_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _query = '';
  final List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: const Text('Search')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final results = provider.expenses.where((e) {
            final matchesQuery = e.category.toLowerCase().contains(_query.toLowerCase()) || 
                                (e.description?.toLowerCase().contains(_query.toLowerCase()) ?? false);
            final matchesFilter = _selectedFilters.isEmpty || _selectedFilters.contains(e.category);
            return matchesQuery && matchesFilter;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppColors.paddingLarge),
                child: _buildSearchBar(),
              ),
              _buildFilterChips(provider.categories.map((c) => c.name).toList()),
              const SizedBox(height: 24),
              Expanded(
                child: results.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
                        physics: const BouncingScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return ExpenseListItem(
                            expense: results[index],
                            onDelete: () => provider.deleteExpense(results[index].id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _query = val),
      decoration: InputDecoration(
        hintText: 'Search by category or note...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
        suffixIcon: _query.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              })
            : null,
      ),
    );
  }

  Widget _buildFilterChips(List<String> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedFilters.contains(cat);
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) _selectedFilters.add(cat); else _selectedFilters.remove(cat);
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.1),
              backgroundColor: AppColors.getSurface(context),
              labelStyle: TextStyle(color: isSelected ? AppColors.primary : AppColors.getTextSecondary(context), fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? AppColors.primary : AppColors.getBorder(context))),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search_rounded, size: 80, color: AppColors.getBorder(context)),
          const SizedBox(height: 24),
          Text(_query.isEmpty ? 'Search your transactions' : 'No results found', 
            style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
