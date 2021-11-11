import 'package:access/app/locator.dart';
import 'package:access/services/user_service.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
}
