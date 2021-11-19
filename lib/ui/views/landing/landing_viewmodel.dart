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

  LandingViewModel() {}

  activateNFCScan() {
    FlutterNfcWeb.instance.startNFCScan(
        onTagDiscovered: (List<JsNdefRecord> records) {
      for (JsNdefRecord record in records) {
        if (record.mediaType == "text/plain" && record.recordType == "mime") {
          this.handleTag(record.data);
        }
      }
      print(records);
    }, onError: (error) {
      print(error);
    }, onPermissionChanged: (permission) {
      print(permission);
      notifyListeners();
    });
  }

  void handleTag(String? tag) {
    if (tag == null) return;
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    if (currentPath == "/") {
      navigatorKey.currentState?.pushNamed("/checkin?room=" + tag);
    } else {
      navigatorKey.currentState?.pushReplacementNamed("/checkin?room=" + tag);
    }
  }
}
