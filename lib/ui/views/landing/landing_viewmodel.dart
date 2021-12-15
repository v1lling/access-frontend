import 'dart:convert';
import 'dart:typed_data';

import 'package:access/app/locator.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/uri_routing_service.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/widgets/panel_error.dart';
import 'package:access/ui/widgets/panel_usercount.dart';
import 'package:flutter/material.dart';
import 'package:access/ui/widgets/panel_scan.dart';
import 'package:access/ui/widgets/panel_success.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  UriRoutingService uriRoutingService = locator<UriRoutingService>();
  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();

  bool? isNfcAvailable = false;

  final PanelController panelController = PanelController();
  Widget panelContent = Container();

  LandingViewModel() {
    checkNFCPermissions();
    /*
    NfcManager.instance.discover(onDiscovered: (NfcTag tag) async {
      String? roomId = await _getUriStringFromTag(tag);
      if (roomId != null) uriRoutingService.navigateFromUri(roomId);
    });
    */
  }

  void checkNFCPermissions() {
    NfcManager.instance.isAvailable().then((isAvailable) {
      this.isNfcAvailable = isAvailable;
      notifyListeners();
    });
  }

  void activateNFCCheckin() {
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      panelController.close();
      String? roomId = await _getUriStringFromTag(tag);
      if (roomId != null) uriRoutingService.navigateFromUri(roomId);
    }, onError: (NfcError error) async {
      print(error);
      panelContent = PanelError();
      notifyListeners();
      checkNFCPermissions(); // in case permissions are the problem (prompt denied)
    });
  }

  void activateNFCCount() async {
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      notifyListeners();
      String? uriString = await _getUriStringFromTag(tag);
      if (uriString != null) {
        String? roomId = _getRoomIdFromUriString(uriString);
        if (roomId != null) {
          var userCount = await _accessBackendService.checkInCount(roomId);
          panelContent = PanelUserCount(roomId: roomId, userCount: userCount);
          notifyListeners();
        }
      }
    }, onError: (NfcError error) async {
      print(error);
      panelContent = PanelError();
      notifyListeners();
      checkNFCPermissions(); // in case permissions are the problem (prompt denied)
    });
  }

  void writeNFC(String? roomId) {
    if (roomId == null) return;
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Ndef? tech = await Ndef.from(tag);
      if (tech is Ndef) {
        final url = Uri.parse("https://access.netpy.de/checkin?room=" + roomId);
        final record = NdefRecord.createUri(url);
        //final record = NdefRecord.createMime("text/json", Uint8List.fromList("lol".codeUnits));
        //final record =
        //  NdefRecord.createText("Was geht mein Kamerad", languageCode: "de");
        //final record = NdefRecord.createExternal("sascha", "schnipi",Uint8List.fromList("hey schnippschnapp".codeUnits));
        final message = NdefMessage([record]);

        await tech.write(message);
        panelContent = PanelSuccess();
        notifyListeners();
      }
    }, onError: (NfcError error) async {
      print(error);
      panelContent = PanelError();
      notifyListeners();
      checkNFCPermissions(); // in case permissions are the problem (prompt denied)
    });
  }

  Future<String?> _getUriStringFromTag(NfcTag tag) async {
    Ndef? tech = await Ndef.from(tag);
    if (tech is Ndef) {
      // find ndef record for navigation
      if (tech.cachedMessage != null) {
        for (NdefRecord record in tech.cachedMessage!.records) {
          if (utf8.decode(record.type) == "U") {
            String targetUri = utf8.decode(record.payload);
            return targetUri;
          }
        }
      }
    }
    return null;
  }

  String? _getRoomIdFromUriString(String? uriString) {
    if (uriString == null) return null;
    Uri targetUri = Uri.dataFromString(uriString);
    return targetUri.queryParameters["room"];
  }
}
