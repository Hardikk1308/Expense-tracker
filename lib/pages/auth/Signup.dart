import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (result['success']) {
      _showMessage('Registration successful! Please login.');
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _showMessage(result['message']);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('successful') ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              
              Text('Start Your\nJourney.', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 12),
              Text('Create an account to begin tracking your financial freedom.', 
                style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 48),

              // Username
              _buildLabel('FULL NAME'),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'John Doe'),
              ),

              const SizedBox(height: 24),

              // Email
              _buildLabel('EMAIL ADDRESS'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'name@example.com'),
              ),

              const SizedBox(height: 24),

              // Password
              _buildLabel('PASSWORD'),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, 
                      color: AppColors.getTextTertiary(context), size: 20),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Signup Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 40),

              // Signin Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: Theme.of(context).textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text('Sign In', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}