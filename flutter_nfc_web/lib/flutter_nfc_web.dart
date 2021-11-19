import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'global.dart';

class FlutterNfcWeb {
  static const MethodChannel _channel = MethodChannel('flutter_nfc_web');

  static FlutterNfcWeb? _instance;

  /// A Singleton instance of NfcManager.
  static FlutterNfcWeb get instance => _instance ??= FlutterNfcWeb._();

  FlutterNfcWeb._();

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String?> getNFCPermissionStatus() async {
    html.PermissionStatus? permission =
        await html.window.navigator.permissions?.query({'name': 'nfc'});
    return permission?.state;
  }

//TODO: should we use html library in this file? maybe we should move it to web_web to avoid it in native apps? Find out!!
  Future<void> startNFCScan(
      {Function? onTagDiscovered,
      Function? onError,
      Function? onPermissionChanged}) async {
    tagDiscoveredCallback = onTagDiscovered;
    errorCallback = onError;
    if (onPermissionChanged != null) {
      permissionChangedCallback = onPermissionChanged;
      html.PermissionStatus? permission =
          await html.window.navigator.permissions?.query({'name': 'nfc'});
      permission?.onChange.listen((event) {
        onPermissionChanged(event);
      });
    }
    await _channel.invokeMethod('startNFCScan');
  }

  Future<void> stopNFCScan() async {
    await _channel.invokeMethod('stopNFCScan');
  }
}
