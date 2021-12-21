import 'dart:async';

import 'package:access/app/locator.dart';
import 'package:access/models/user.dart';
import 'package:access/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class UserInfoViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  StreamSubscription<User>? userStreamSub;

  final givennameController = TextEditingController();
  final familynameController = TextEditingController();
  final streetController = TextEditingController();
  final postalcodeController = TextEditingController();
  final townController = TextEditingController();
  final mobilenumberController = TextEditingController();

  UserInfoViewModel() {
    userStreamSub = _userService.user.listen((user) {
      fillUserInfo(user);
    });
  }

  @override
  void dispose() {
    userStreamSub?.cancel();
    super.dispose();
  }

  Future fillUserInfo(User user) async {
    // fill textformfields with cached user
    givennameController.text = user.givenname;
    familynameController.text = user.familyname;
    streetController.text = user.street;
    postalcodeController.text = user.postalcode;
    townController.text = user.town;
    mobilenumberController.text = user.mobilenumber;
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
