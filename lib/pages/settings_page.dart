import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../services/token_manager.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';
import 'category_management_page.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await TokenManager.getUserData();
    setState(() => userData = data);
  }

  Future<void> _logout() async {
    await TokenManager.clearAll();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  void _showSetBudgetDialog() {
    final provider = context.read<ExpenseProvider>();
    final controller = TextEditingController(text: (provider.budget?.monthlyLimit ?? 0).toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 32, left: 24, right: 24),
        decoration: BoxDecoration(color: AppColors.getSurface(context), borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Budget', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 32),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: Theme.of(context).textTheme.displayMedium,
              decoration: const InputDecoration(prefixText: '₹ '),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  await provider.setMonthlyBudget(double.tryParse(controller.text) ?? 0);
                  Navigator.pop(context);
                },
                child: const Text('Update Budget'),
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
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppColors.paddingLarge),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 40),
            _buildSettingsSection('ACCOUNT & FINANCE', [
              _buildSettingsItem(Icons.account_balance_wallet_outlined, 'Monthly Budget', _showSetBudgetDialog, 
                subtitle: 'Current Limit: ₹${(context.watch<ExpenseProvider>().budget?.monthlyLimit ?? 0).toStringAsFixed(0)}'),
              _buildSettingsItem(Icons.category_outlined, 'Manage Categories', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagementPage()));
              }),
            ]),
            const SizedBox(height: 24),
            _buildSettingsSection('APP PREFERENCES', [
              _buildSettingsItem(Icons.notifications_none, 'Notifications', () {}, trailing: Switch(value: true, onChanged: (v) {}, activeColor: AppColors.primary)),
              _buildSettingsItem(Icons.dark_mode_outlined, 'Dark Mode', () {}, subtitle: 'Follow system settings'),
            ]),
            const SizedBox(height: 24),
            _buildSettingsSection('SUPPORT', [
              _buildSettingsItem(Icons.help_outline, 'Help Center', () {}),
              _buildSettingsItem(Icons.info_outline, 'About Developer', () {}),
            ]),
            const SizedBox(height: 48),
            _buildLogoutButton(),
            const SizedBox(height: 24),
            Text('Version 2.5.4', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1), 
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 4),
          ),
          child: const Center(child: Icon(Icons.person_rounded, size: 48, color: AppColors.primary)),
        ),
        const SizedBox(height: 16),
        Text(userData?['username'] ?? 'User', style: Theme.of(context).textTheme.headlineMedium),
        Text(userData?['email'] ?? 'user@example.com', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2)),
        ),
        CustomCard(padding: EdgeInsets.zero, child: Column(children: items)),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing, String? subtitle}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.getBackground(context), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall) : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: AppColors.getBorder(context), size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: const Text('Sign Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
