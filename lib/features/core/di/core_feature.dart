import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../events/event_broker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../config/environment.dart';
import '../network/api_client.dart';
import '../network/middleware.dart';
import '../handlers/event_logger.dart';

final getIt = GetIt.instance;

extension CoreFeatureRegistration on GetIt {
  Future<void> registerCoreFeature() async {
    registerSingleton<EventBroker>(EventBroker());
    final apiClient = ApiClient(
      getIt<http.Client>(),
      getIt<Environment>(),
      [AuthMiddleware(getIt<SharedPreferences>())],
    );
    getIt.registerSingleton<ApiClient>(apiClient);
    registerLazySingleton<EventLogger>(
      () => EventLogger(getIt<EventBroker>(), getIt<Logger>()),
    );
    
    getIt<EventLogger>();  // This will create the logger and start listening for events
  }
} 