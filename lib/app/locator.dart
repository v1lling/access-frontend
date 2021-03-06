import 'package:access/services/access_backend_service.dart';
import 'package:access/services/dynamic_link_service.dart';
import 'package:access/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AccessBackendService());
  locator.registerLazySingleton(() => UserService());
}
