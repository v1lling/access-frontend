import 'dart:convert';

import 'package:access/app/locator.dart';
import 'package:access/main.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:nfc_manager/platform_tags.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  String nfc = "";

  LandingViewModel() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        this.handleTag(tag);
      },
    );
  }

  void handleTag(NfcTag tag) async {
    Ndef? tech = await Ndef.from(tag);
    if (tech is Ndef) {
      NdefMessage lol = await tech.read();
      String? currentPath;
      // get current path
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });
      final roomId = utf8.decode(lol.records[0].payload);
      if (currentPath == "/") {
        navigatorKey.currentState?.pushNamed("/checkin?room=" + roomId);
      } else {
        navigatorKey.currentState
            ?.pushReplacementNamed("/checkin?room=" + roomId);
      }
    }
  }
}
