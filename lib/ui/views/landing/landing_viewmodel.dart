import 'dart:convert';

import 'package:access/app/locator.dart';
import 'package:access/main.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_web/flutter_nfc_web.dart';
import 'package:flutter_nfc_web/flutter_nfc_web_web.dart';
import 'package:flutter_nfc_web/js_ndef_record.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
}
