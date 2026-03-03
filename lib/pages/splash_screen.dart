import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../services/token_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    final isLoggedIn = await TokenManager.isLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: AppColors.textOnPrimary,
            ),
            SizedBox(height: 24),
            Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnPrimary,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              color: AppColors.textOnPrimary,
            ),
          ],
        ),
      ),
    );
  }
}