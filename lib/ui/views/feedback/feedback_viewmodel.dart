import 'dart:async';

import 'package:access/app/locator.dart';
import 'package:access/models/user.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class FeedbackViewModel extends BaseViewModel {
  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();
  final deviceController = TextEditingController();

  Future fillUserInfo(User user) async {
    // fill textformfields with cached user
    deviceController.text = user.givenname;

    return;
  }

  void safeUserInfo(BuildContext context) async {
    // create user instance
    final feedback = {"device": deviceController.text, "web": kIsWeb};
    // save to local storage
    _accessBackendService.sendFeedback(feedback);
    // navigate back
    Navigator.of(context).pop();
  }
}
