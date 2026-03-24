import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expense_provider.dart';
import '../provider/app_settings_provider.dart';
import '../services/token_manager.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_card.dart';
import '../l10n/app_localizations.dart';
import 'category_management_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: Text(l10n.translate('settings'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppColors.paddingLarge),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 40),
            _buildSettingsSection(l10n.translate('finance'), [
              _buildSettingsItem(Icons.account_balance_wallet_outlined, l10n.translate('update_budget'), () {}),
              _buildSettingsItem(Icons.category_outlined, l10n.translate('category'), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagementPage()));
              }),
            ]),
            const SizedBox(height: 24),
            _buildSettingsSection(l10n.translate('app_prefs'), [
              _buildThemeSwitcher(settings, l10n),
              _buildLanguageSwitcher(settings, l10n),
            ]),
            const SizedBox(height: 48),
            _buildLogoutButton(l10n),
            const SizedBox(height: 24),
            Text('Version 2.7.0', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 60), // Extra space for bottom nav
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
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 4)),
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
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 12), child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2))),
        CustomCard(padding: EdgeInsets.zero, child: Column(children: items)),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.getBackground(context), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      trailing: trailing ?? Icon(Icons.chevron_right, color: AppColors.getBorder(context), size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildThemeSwitcher(AppSettingsProvider settings, AppLocalizations l10n) {
    return _buildSettingsItem(
      Icons.dark_mode_outlined,
      l10n.translate('theme'),
      () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.translate('theme')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _themeOption(ThemeModeOption.light, 'Light', settings),
                _themeOption(ThemeModeOption.dark, 'Dark', settings),
                _themeOption(ThemeModeOption.system, l10n.translate('system_default'), settings),
              ],
            ),
          ),
        );
      },
      trailing: Text(settings.themeModeOption.name.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
    );
  }

  Widget _themeOption(ThemeModeOption option, String label, AppSettingsProvider settings) {
    return RadioListTile<ThemeModeOption>(
      value: option, groupValue: settings.themeModeOption,
      title: Text(label),
      onChanged: (val) {
        settings.setThemeMode(val!);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLanguageSwitcher(AppSettingsProvider settings, AppLocalizations l10n) {
    return _buildSettingsItem(
      Icons.language_rounded,
      l10n.translate('language'),
      () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _langOption('en', 'English (UK)', settings),
                _langOption('hi', 'हिंदी (Indian)', settings),
                _langOption('mr', 'मराठी (Regional)', settings),
              ],
            ),
          ),
        );
      },
      trailing: Text(settings.locale.languageCode.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
    );
  }

  Widget _langOption(String code, String label, AppSettingsProvider settings) {
    bool active = settings.locale.languageCode == code;
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.normal, color: active ? AppColors.primary : null)),
      trailing: active ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
      onTap: () {
        settings.setLocale(code);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLogoutButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity, height: 60,
      child: TextButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text(l10n.translate('logout'), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(backgroundColor: AppColors.error.withOpacity(0.05), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ),
    );
  }
}
