import 'package:access/app/locator.dart';
import 'package:access/models/user.dart';
import 'package:access/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class UserInfoViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();

  final givennameController = TextEditingController();
  final familynameController = TextEditingController();
  final streetController = TextEditingController();
  final postalcodeController = TextEditingController();
  final townController = TextEditingController();
  final mobilenumberController = TextEditingController();
  UserInfoViewModel() {
    fillUserInfo();
  }
  Future fillUserInfo() async {
    // fill textformfields with cached user
    final user = _userService.user!;
    if (user.givenname != null) givennameController.text = user.givenname!;
    if (user.familyname != null) familynameController.text = user.familyname!;
    if (user.street != null) streetController.text = user.street!;
    if (user.postalcode != null) postalcodeController.text = user.postalcode!;
    if (user.town != null) townController.text = user.town!;
    if (user.mobilenumber != null)
      mobilenumberController.text = user.mobilenumber!;
    return;
  }

  void safeUserInfo(BuildContext context) async {
    // create user instance
    final user = new User(
      givenname: givennameController.text,
      familyname: familynameController.text,
      street: streetController.text,
      postalcode: postalcodeController.text,
      town: townController.text,
      mobilenumber: mobilenumberController.text,
    );
    // save to local storage
    _userService.saveUser(user);
    // navigate back
    Navigator.of(context).pop();
  }
}
