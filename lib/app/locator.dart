import 'package:access/services/access_backend_service.dart';
import 'package:access/services/user_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AccessBackendService());
  locator.registerLazySingleton(() => UserService());
}
