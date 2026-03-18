import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Expense> _allExpenses = [];
  bool _isLoading = true;

  List<String> selectedFilters = [];

  final List<String> naturalLanguageQueries = [
    'Transport costs',
    'Food purchases',
    'Credit card expenses',
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadExpenses() async {
    final result = await ExpenseService.getExpenses();
    if (result['success']) {
      setState(() {
        _allExpenses = result['expenses'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Expense> get _filteredExpenses {
    var filtered = _allExpenses;

    // Quick Filters
    if (selectedFilters.contains('This Week')) {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      filtered = filtered.where((e) => e.expenseDate.isAfter(weekAgo)).toList();
    }
    if (selectedFilters.contains('This Month')) {
      final now = DateTime.now();
      filtered = filtered
          .where(
            (e) =>
                e.expenseDate.month == now.month &&
                e.expenseDate.year == now.year,
          )
          .toList();
    }
    if (selectedFilters.contains('Food')) {
      filtered = filtered
          .where((e) => e.category.toLowerCase().contains('food'))
          .toList();
    }
    if (selectedFilters.contains('Over ₹20')) {
      filtered = filtered.where((e) => e.amount > 20).toList();
    }

    // Text Search
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((e) {
        final matchesDesc =
            e.description?.toLowerCase().contains(query) ?? false;
        final matchesCat = e.category.toLowerCase().contains(query);
        return matchesDesc || matchesCat;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredExpenses;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Search & Filter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search expenses...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Natural Language Suggestions
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Try searching for:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: naturalLanguageQueries.map((query) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = query.split(' ').first;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Text(
                      query,
                      style: const TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Quick Filters
            const Text(
              'Quick Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFilterChip('This Week'),
                _buildFilterChip('This Month'),
                _buildFilterChip('Food'),
                _buildFilterChip('Over ₹20'),
              ],
            ),

            const SizedBox(height: 32),

            // Results
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isLoading ? 'Loading...' : '${results.length} Results',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (selectedFilters.isNotEmpty ||
                    _searchController.text.isNotEmpty)
                  Row(
                    children: [
                      const Text(
                        'Filtered',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.sort, color: Colors.grey, size: 20),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Search Results
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (results.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No expenses found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final expense = results[index];
                    return _buildSearchResultItem(expense);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilters.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedFilters.add(label);
          } else {
            selectedFilters.remove(label);
          }
        });
      },
      selectedColor: Colors.deepPurple.withOpacity(0.2),
      checkmarkColor: Colors.deepPurple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepPurple : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildSearchResultItem(Expense expense) {
    IconData icon;
    Color iconColor;

    switch (expense.category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case 'transport':
      case 'transportation':
      case 'trip':
        icon = Icons.directions_car;
        iconColor = Colors.red;
        break;
      case 'bills':
      case 'bills & utilities':
        icon = Icons.receipt;
        iconColor = Colors.blue;
        break;
      case 'shopping':
        icon = Icons.shopping_bag;
        iconColor = Colors.purple;
        break;
      case 'healthcare':
        icon = Icons.local_hospital;
        iconColor = Colors.pink;
        break;
      case 'entertainment':
        icon = Icons.movie;
        iconColor = Colors.indigo;
        break;
      case 'coffee':
      case 'coffee & drinks':
        icon = Icons.local_cafe;
        iconColor = Colors.brown;
        break;
      default:
        icon = Icons.label;
        iconColor = Colors.deepPurple;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.displayTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      expense.category,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.credit_card, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Text(
                      'Card/Cash',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      expense.formattedDate,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            expense.formattedAmountWithSign,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
