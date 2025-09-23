class AppConstants {
  static const String baseUrl = "http://45.144.65.247/api"; // 'http://185.105.90.34/api';
  static const String appName = 'VDM Mobile';
  static const String appVersion = '1.0.0';

  // Fonts
  static const String fontFamily = 'Inter';

  // Auth
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String usersEndpoint = '/users';
  static String driversEndpoint = '/drivers';

  // User management endpoints
  static String userToggleStatusEndpoint(int userId) => '/users/$userId/toggle-status';
  static String userDeleteEndpoint(int userId) => '/users/$userId';

  // Routes
  static const String routeSplash = '/splash';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeUsers = '/users';
  static const String routeUserDetail = '/users/:id';
  static String getUserDetailPath(int id) => '/users/$id';

  // Timeouts
  static const int connectTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 10000;

}