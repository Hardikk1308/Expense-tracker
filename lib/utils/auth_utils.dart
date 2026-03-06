import 'package:flutter/material.dart';
import '../services/token_manager.dart';

class AuthUtils {
  // Handle authentication errors and redirect to login
  static Future<bool> handleAuthError(BuildContext context, Map<String, dynamic> result) async {
    if (result['requiresLogin'] == true || result['needsLogin'] == true) {
      await TokenManager.clearAll();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/login', 
          (route) => false,
        );
      }
      return true; // Indicates auth error was handled
    }
    return false; // No auth error
  }

  // Check if user is authenticated before making API calls
  static Future<bool> isAuthenticated() async {
    return await TokenManager.isLoggedIn();
  }

  // Show authentication required dialog
  static void showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text('Your session has expired. Please login again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/login', 
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}