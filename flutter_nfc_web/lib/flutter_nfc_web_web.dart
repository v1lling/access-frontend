@JS()
library flutter_nfc.js;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_nfc_web/global.dart';
import 'package:flutter_nfc_web/js_ndef_record.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

/// A web implementation of the FlutterNfcWeb plugin.
class FlutterNfcWebWeb {
  static void registerWith(Registrar registrar) {
    // insert js file into html body
    html.document.body!.append(html.ScriptElement()
      ..src =
          'assets/packages/flutter_nfc_web/assets/flutter_nfc.js' // ignore: unsafe_html
      ..type = 'application/javascript'
      ..defer = true);

    //register methodchannel
    final MethodChannel channel = MethodChannel(
      'flutter_nfc_web',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterNfcWebWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'startNFCScan':
        return _startNFCScan();
      case 'stopNFCScan':
        _stopNFCScan();
        return;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_nfc_web for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Starts the NFCReader on JS-side
  _startNFCScan() async {
    html.document.on['tagDiscoveredJS'].listen((html.Event event) {
      List<String> records = (event as html.CustomEvent).detail;
      List<JsNdefRecord> ndefRecords = [];
      for (String record in records) {
        ndefRecords.add(JsNdefRecord.fromJson(json.decode(record)));
      }
      tagDiscoveredCallback?.call(ndefRecords);
    });
    html.document.on['errorJS'].listen((html.Event event) {
      errorCallback?.call();
    });
    startNDEFReaderJS();
  }

  // Stops the current NFCReader
  _stopNFCScan() {
    return stopNDEFReaderJS();
  }
}

@JS()
external dynamic startNDEFReaderJS();
external dynamic stopNDEFReaderJS();
