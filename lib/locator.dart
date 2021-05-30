import 'package:captube/services/api.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => Api());
  locator.registerSingleton(() => FirebaseAnalytics());
}
