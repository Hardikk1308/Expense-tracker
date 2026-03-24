class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Standard for Android Emulator to access localhost
  // static const String baseUrl = 'http://localhost:3000/api'; // For iOS/Web
  // static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com/api'; // Production
  
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
