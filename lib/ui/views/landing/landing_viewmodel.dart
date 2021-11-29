import 'dart:convert';

import 'package:access/app/locator.dart';
import 'package:access/main.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:flutter/material.dart';
import 'package:access/ui/widgets/panel_scan.dart';
import 'package:access/ui/widgets/panel_success.dart';
import 'package:access/ui/widgets/panel_usercount.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  bool? isNfcAvailable = false;
  String? nfcPermission = "denied";

  final PanelController panelController = PanelController();
  Widget panelContent = Container();

  LandingViewModel() {
    this.isNfcAvailable = true;
    this.nfcPermission = "granted";
    notifyListeners();
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        this.handleTag(tag);
      },
    );
    /*
    FlutterNfcWeb.instance.isNFCWebAvailable().then((bool? isAvailable) {
      this.isNfcAvailable = isAvailable;
      if (isAvailable!) {
        FlutterNfcWeb.instance
            .getNFCPermissionStatus()
            .then((String? permission) {
          this.nfcPermission = permission;
          notifyListeners();
        });
      }
    });
    */
  }

  activateNFCScan() {
    panelContent = PanelScan();
    notifyListeners();
    /*
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
    */
  }

  writeNFC() {
    panelContent = PanelScan();
    notifyListeners();
    /*
    FlutterNfcWeb.instance.startNFCWrite([
      JsNdefRecord(
          data: "https://access.netpy.de/#/checkin?room=Test",
          recordType: "url")
    ], onWriteSuccess: () {
      panelContent = PanelSuccess();
      notifyListeners();
      print("its done");
    }, onError: (errorMsg) {
      print(errorMsg);
    });
    */
  }

  void handleTag(NfcTag tag) async {
    Ndef? tech = await Ndef.from(tag);
    if (tech is Ndef) {
      // get current path
      String? currentPath;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });

      // find ndef record for navigation
      for (NdefRecord record in tech.cachedMessage!.records) {
        if ((utf8.decode(record.type) == "U" && record.payload != null) ||
            ( // Android
                utf8.decode(record.type) == "url" &&
                    record.payload != null)) // Web
        {
          Uri targetUri = Uri.dataFromString(utf8.decode(record.payload));
          String? roomId = targetUri.queryParameters["room"];
          if (roomId == null) return;
          if (currentPath == "/") {
            navigatorKey.currentState?.pushNamed("/checkin?room=" + roomId);
          } else {
            navigatorKey.currentState
                ?.pushReplacementNamed("/checkin?room=" + roomId);
          }
        }
      }
    }
  }
}
