import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'environment.dart';
import '../features/core/di/core_feature.dart';
import '../features/task/di/task_feature.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(Environment environment) async {
  // Core dependencies
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<Environment>(environment);
  getIt.registerSingleton<http.Client>(http.Client());
  getIt.registerSingleton<Logger>(Logger());
}

Future<void> setupDependencies() async {
  await setupServiceLocator(await Environment.load());
  await getIt.registerCoreFeature();
  await getIt.registerTaskFeature();
} 