import 'package:flutter/material.dart';
import '../services/token_manager.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';

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
    setState(() {
      userData = data;
    });
  }

  Future<void> _logout() async {
    await TokenManager.clearAll();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),
            _buildSettingsSection(
              'Account',
              [
                _buildSettingsItem(Icons.person_outline, 'Profile Information', () {}),
                _buildSettingsItem(Icons.account_balance_wallet_outlined, 'Budget Management', () {}),
                _buildSettingsItem(Icons.category_outlined, 'Categories', () {}),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Preferences',
              [
                _buildSettingsItem(Icons.notifications_none, 'Notifications', () {}, trailing: _buildSwitch(true)),
                _buildSettingsItem(Icons.dark_mode_outlined, 'Dark Mode', () {}, trailing: _buildSwitch(false)),
                _buildSettingsItem(Icons.language, 'Language', () {}, subtitle: 'English'),
              ],
            ),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 24),
            const Text(
              'Expense Tracker v2.0.0',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userData?['username'] ?? 'User',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        Text(
          userData?['email'] ?? 'user@example.com',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 1),
          ),
        ),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing, String? subtitle}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildSwitch(bool value) {
    return Switch(
      value: value,
      onChanged: (val) {},
      activeColor: AppColors.primary,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
