import 'base_api_service.dart';
import 'token_manager.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await BaseApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (result['success']) {
      final token = result['data']['token'];
      if (token != null) {
        await TokenManager.saveToken(token);
        
        // Fetch and save user info
        final userResult = await getUserInfo();
        if (userResult['success']) {
          final userData = userResult['data'];
          await TokenManager.saveUserData(
            userId: userData['id'].toString(),
            username: userData['username'],
            email: userData['email'],
          );
        }
      }
      return {
        'success': true,
        'message': result['message'] ?? 'Login successful',
        'token': token,
      };
    }
    return result;
  }

  // Register
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final result = await BaseApiService.post('/auth/register', {
      'username': username,
      'email': email,
      'password': password,
    });

    if (result['success']) {
      final userData = result['data']['user'];
      if (userData != null) {
        await TokenManager.saveUserData(
          userId: userData['id'].toString(),
          username: userData['username'],
          email: userData['email'],
        );
      }
      return {
        'success': true,
        'message': result['message'] ?? 'Registration successful',
        'user': userData,
      };
    }
    return result;
  }

  // Get User Info
  static Future<Map<String, dynamic>> getUserInfo() async {
    return await BaseApiService.get('/auth/userinfo');
  }

  // Logout
  static Future<void> logout() async {
    await TokenManager.clearAll();
  }
}