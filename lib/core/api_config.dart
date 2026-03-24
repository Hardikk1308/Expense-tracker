class ApiConfig {
  static const String baseUrl = 'https://expense-tracker-3-gywh.onrender.com/api'; // Production / Render
  // static const String baseUrl = 'http://10.0.2.2:3000/api'; // For Local Testing
  
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
