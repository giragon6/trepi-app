class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://trepi-api.giragon6.hackclub.app/api/v1',
  );

  static const bool isProduction = bool.fromEnvironment('PRODUCTION');
}