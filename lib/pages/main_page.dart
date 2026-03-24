import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_expense_page.dart';
import 'analytics_page.dart';
import 'settings_page.dart';
import '../constants/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  void _onAddPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(
          onFinished: () => Navigator.pop(context),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.getBackground(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPressed,
        backgroundColor: AppColors.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, size: 36, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          boxShadow: [AppColors.softShadow(context)],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          notchMargin: 12,
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.auto_graph_rounded, 'Analytics'),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(2, Icons.settings_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.getTextTertiary(context).withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.getTextTertiary(context).withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
