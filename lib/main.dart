import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'pages/splash_screen.dart';
import 'pages/auth/login.dart';
import 'pages/auth/Signup.dart';
import 'pages/main_page.dart';

void main() {
  print('🚀 MAIN: Starting Expense Tracker app...');
  print('🏗️ MAIN: Initializing Flutter app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print('🏗️ MyApp: Building MaterialApp...');
    // print('🎨 MyApp: Using theme: ${AppTheme.lightTheme.toString().substring(0, 50)}...');
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) {
          print('🏠 ROUTE: Navigating to SplashScreen');
          return const SplashScreen();
        },
        '/login': (context) {
          print('🔐 ROUTE: Navigating to LoginPage');
          return const LoginPage();
        },
        '/signup': (context) {
          print('📝 ROUTE: Navigating to SignupPage');
          return const SignupPage();
        },
        '/home': (context) {
          print('🏡 ROUTE: Navigating to MainPage');
          return const MainPage();
        },
      },
    );
  }
}
