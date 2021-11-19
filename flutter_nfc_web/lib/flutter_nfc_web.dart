import 'dart:async';

import 'package:flutter/services.dart';

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

  Future<void> startNFCScan(
      {Function? onTagDiscovered, Function? onError}) async {
    tagDiscoveredCallback = onTagDiscovered;
    errorCallback = onError;
    await _channel.invokeMethod('startNFCScan');
  }

  Future<void> stopNFCScan() async {
    await _channel.invokeMethod('stopNFCScan');
  }
}
