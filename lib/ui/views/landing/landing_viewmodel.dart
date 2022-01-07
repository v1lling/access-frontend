import 'dart:async';
import 'dart:convert';
import 'package:access/app/locator.dart';
import 'package:access/models/user.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/widgets/panel_error.dart';
import 'package:access/ui/widgets/panel_usercount.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:access/ui/widgets/panel_scan.dart';
import 'package:access/ui/widgets/panel_success.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends ReactiveViewModel {
  UserService userService = locator<UserService>();
  StreamSubscription<User>? userStreamSub;
  User user = User.empty();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [userService];

  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();

  bool? isNfcAvailable = false;

  final PanelController panelController = PanelController();
  Widget panelContent = Container();

  LandingViewModel() {
    checkNFCPermissions();
    this.user = userService.user.value;
    userStreamSub = userService.user.listen((v) {
      this.user = v;
    });
    /*
    NfcManager.instance.discover(onDiscovered: (NfcTag tag) async {
      String? roomId = await _getUriStringFromTag(tag);
      if (roomId != null) uriRoutingService.navigateFromUri(roomId);
    });
    */
  }

  @override
  void dispose() {
    userStreamSub?.cancel();
    super.dispose();
  }

  void checkNFCPermissions() {
    NfcManager.instance.isAvailable().then((isAvailable) {
      this.isNfcAvailable = isAvailable;
      notifyListeners();
    });
  }

  void activateNFCCheckin(ValueChanged<String>? didCheckInScan) {
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      String? uriString = await _getUriStringFromTag(tag);
      if (uriString != null) {
        String? roomId = _getRoomIdFromUriString(uriString);
        bool isExisting = await _accessBackendService.getIsRoomExisting(roomId);
        if (roomId != null && isExisting) {
          didCheckInScan?.call(roomId);
          panelController.close();
        } else {
          panelContent = PanelError();
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

  void activateNFCCount() async {
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      notifyListeners();
      String? uriString = await _getUriStringFromTag(tag);
      if (uriString != null) {
        String? roomId = _getRoomIdFromUriString(uriString);
        bool isExisting = await _accessBackendService.getIsRoomExisting(roomId);
        if (roomId != null && isExisting) {
          var userCount = await _accessBackendService.checkInCount(roomId);
          panelContent = PanelUserCount(roomId: roomId, userCount: userCount);
          notifyListeners();
        } else {
          panelContent = PanelError();
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
        final url = Uri.parse("https://access.netpy.de/checkin/" + roomId);
        final record = NdefRecord.createUri(url);
        //final record = NdefRecord.createMime("text/json", Uint8List.fromList("lol".codeUnits));
        //final record =
        //  NdefRecord.createText("Was geht mein Kamerad", languageCode: "de");
        //final record = NdefRecord.createExternal("sascha", "schnipi",Uint8List.fromList("hey schnippschnapp".codeUnits));
        final message = NdefMessage([record]);
        await tech.write(message);
        await _accessBackendService.createRoom(roomId);
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
    if (tech is Ndef && tech.cachedMessage != null) {
      for (NdefRecord record in tech.cachedMessage!.records) {
        if (utf8.decode(record.type) == "U") {
          if (kIsWeb) {
            // URI prefix already decoded from Web NFC by default
            return utf8.decode(record.payload);
          } else {
            // URI prefix needs to be decoded first
            return NdefRecord.URI_PREFIX_LIST[record.payload[0]] +
                utf8.decode(record.payload.sublist(1));
          }
        }
      }
    }
    return null;
  }

  String? _getRoomIdFromUriString(String? uriString) {
    final uri = Uri.parse(uriString!);
    if (uri.pathSegments.length != 2) return null;
    final pageName = uri.pathSegments.elementAt(0).toString();
    if (pageName == "checkin") {
      return uri.pathSegments.elementAt(1).toString();
    }
    return null;
  }
}
