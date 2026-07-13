import 'package:flutter/foundation.dart';

class EnvironmentConfig {
  // Can be expanded to read from .env or flavors later
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb ? 'http://localhost:5128/api' : 'http://10.0.2.2:5128/api',
  );
}
