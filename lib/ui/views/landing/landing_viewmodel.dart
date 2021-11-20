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
  bool? isNfcAvailable = false;
  String? nfcPermission = "denied";

  LandingViewModel() {
    FlutterNfcWeb.instance.isNFCWebAvailable().then((bool? isAvailable) {
      this.isNfcAvailable = isAvailable;
      if (isAvailable!) {
        FlutterNfcWeb.instance
            .getNFCPermissionStatus()
            .then((String? permission) {
          this.nfcPermission = permission;
          if (permission == "granted") activateNFCScan();
          notifyListeners();
        });
      }
    });
  }

  activateNFCScan() {
    FlutterNfcWeb.instance.startNFCRead(
        onTagDiscovered: (List<JsNdefRecord> records) {
      for (JsNdefRecord record in records) {
        if (record.recordType == "url" && record.data != null) {
          Uri targetUri = Uri.dataFromString(record.data!);
          String? roomId = targetUri.queryParameters["room"];
          this.handleTag(roomId);
        }
      }
    }, onError: (error) {
      print(error);
    }, onPermissionChanged: (permission) {
      this.nfcPermission = permission;
      notifyListeners();
    });
  }

  writeNFC() {
    FlutterNfcWeb.instance.startNFCWrite([
      JsNdefRecord(data: "https://access.netpy.de?room=Test", recordType: "url")
    ], onWriteSuccess: () {
      print("its done");
    }, onError: (errorMsg) {
      print(errorMsg);
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
