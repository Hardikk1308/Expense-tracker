import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _tokenExpiryKey = 'token_expiry';

  // Save token and user data with expiry
  static Future<void> saveToken(String token) async {
    print('💾 TokenManager.saveToken() called');
    print('🎫 Token to save: ${token.substring(0, 20)}...');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('✅ Token saved to SharedPreferences');
    
    // JWT tokens from backend expire in 30 days
    final expiryTime = DateTime.now().add(const Duration(days: 30));
    await prefs.setString(_tokenExpiryKey, expiryTime.toIso8601String());
    print('⏰ Token expiry set to: $expiryTime');
  }

  static Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  // Get token only if it's not expired
  static Future<String?> getToken() async {
    print('🔍 TokenManager.getToken() called');
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryString = prefs.getString(_tokenExpiryKey);
    
    print('🎫 Stored token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
    print('⏰ Stored expiry: $expiryString');
    
    if (token == null || expiryString == null) {
      print('❌ Token or expiry is null');
      return null;
    }
    
    final expiryTime = DateTime.parse(expiryString);
    final now = DateTime.now();
    print('🕐 Current time: $now');
    print('⏰ Expiry time: $expiryTime');
    
    if (now.isAfter(expiryTime)) {
      print('⏰ Token expired, clearing...');
      // Token expired, clear it
      await clearAll();
      return null;
    }
    
    print('✅ Token is valid');
    return token;
  }

  // Get user data
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'username': prefs.getString(_usernameKey),
      'email': prefs.getString(_emailKey),
    };
  }

  // Check if user is logged in with valid token
  static Future<bool> isLoggedIn() async {
    print('🔐 TokenManager.isLoggedIn() called');
    final token = await getToken();
    final result = token != null && token.isNotEmpty;
    print('✅ Is logged in: $result');
    return result;
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_tokenExpiryKey);
    
    if (expiryString == null) {
      return true;
    }
    
    final expiryTime = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiryTime);
  }

  // Clear all stored data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenExpiryKey);
  }

  // Get authorization header for API calls
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}