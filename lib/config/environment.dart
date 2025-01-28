import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

class Environment {
  final String apiBaseUrl;
  final String environment;

  const Environment._({
    required this.apiBaseUrl,
    required this.environment,
  });

  @visibleForTesting
  const Environment.test({
    this.apiBaseUrl = 'https://test.api.com/v1',
    this.environment = 'test',
  });

  static Future<Environment> load() async {
    try {
      await dotenv.load();

      final apiBaseUrl = dotenv.env['API_BASE_URL'];
      final environment = dotenv.env['ENVIRONMENT'];

      if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
        throw Exception(
            'Environment configuration error: API_BASE_URL not found in .env file');
      }

      if (environment == null || environment.isEmpty) {
        throw Exception(
            'Environment configuration error: ENVIRONMENT not found in .env file');
      }

      if (!['development', 'staging', 'production'].contains(environment)) {
        throw Exception(
            'Environment configuration error: ENVIRONMENT must be one of: development, staging, production');
      }

      return Environment._(
        apiBaseUrl: apiBaseUrl,
        environment: environment,
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load environment configuration: ${e.toString()}');
    }
  }
} 