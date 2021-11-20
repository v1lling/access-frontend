import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_nfc_web/js_ndef_record.dart';
import 'dart:html' as html;
import 'global.dart';

class FlutterNfcWeb {
  static const MethodChannel _channel = MethodChannel('flutter_nfc_web');

  static FlutterNfcWeb? _instance;

  /// A Singleton instance of NfcManager.
  static FlutterNfcWeb get instance => _instance ??= FlutterNfcWeb._();

  FlutterNfcWeb._();

  Future<bool?> isNFCWebAvailable() async {
    try {
      await html.window.navigator.permissions?.query({'name': 'nfc'});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getNFCPermissionStatus() async {
    html.PermissionStatus? permission =
        await html.window.navigator.permissions?.query({'name': 'nfc'});
    return permission?.state;
  }

//TODO: should we use html library in this file? maybe we should move it to web_web to avoid it in native apps? Find out!!
  Future<void> startNFCRead(
      {Function? onTagDiscovered,
      Function? onError,
      Function? onPermissionChanged}) async {
    tagDiscoveredCallback = onTagDiscovered;
    readErrorCallback = onError;
    if (onPermissionChanged != null) {
      permissionChangedCallback = onPermissionChanged;
      html.PermissionStatus? permission =
          await html.window.navigator.permissions?.query({'name': 'nfc'});
      permission?.onChange.listen((event) {
        onPermissionChanged(permission.state);
      });
    }
    await _channel.invokeMethod('startNFCRead');
  }

  Future<void> stopNFCScan() async {
    await _channel.invokeMethod('stopNFCScan');
  }

  Future<void> startNFCWrite(List<JsNdefRecord> records,
      {Function? onWriteSuccess, Function? onError}) async {
    writeSuccessfullCallback = onWriteSuccess;
    writeErrorCallback = onError;
    List<String> recordsString = [];
    for (JsNdefRecord record in records) {
      recordsString.add(jsonEncode(record));
    }
    await _channel.invokeMethod('startNFCWrite', {'records': recordsString});
  }
}
