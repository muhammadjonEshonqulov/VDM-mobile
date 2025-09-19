class AppConstants {
  static const String baseUrl = "http://45.144.65.247/api"; // 'http://185.105.90.34/api';
  static const String appName = 'VDM Mobile';
  static const String appVersion = '1.0.0';

  // Auth
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String usersEndpoint = '/users';
  
  // User management endpoints
  static String userToggleStatusEndpoint(int userId) => '/users/$userId/toggle-status';
  static String userDeleteEndpoint(int userId) => '/users/$userId';

  // Timeouts
  static const int connectTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 10000; // 10 seconds
}