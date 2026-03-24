import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_expense_page.dart';
import 'analytics_page.dart';
import 'settings_page.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.getBackground(context),
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddExpensePage(onFinished: () => Navigator.pop(context)), fullscreenDialog: true)),
        backgroundColor: AppColors.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BottomAppBar(
          height: 64, // Compact height
          padding: EdgeInsets.zero,
          notchMargin: 10,
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, l10n.translate('dashboard')),
              _buildNavItem(1, Icons.auto_graph_rounded, l10n.translate('analytics')),
              const Spacer(flex: 2), // Space for FAB
              _buildNavItem(2, Icons.settings_rounded, l10n.translate('settings')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == (index > 1 ? index - 1 : index); 
    // Wait, let's fix the indexing logic for 3 pages but 4 items in row.
    // Index 0, 1, (Spacer), 2
    
    int pageIndex = index;
    bool active = _currentIndex == pageIndex;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = pageIndex),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? AppColors.primary : AppColors.getTextTertiary(context).withOpacity(0.4), size: 24),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: active ? AppColors.primary : AppColors.getTextTertiary(context).withOpacity(0.4), fontWeight: active ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
