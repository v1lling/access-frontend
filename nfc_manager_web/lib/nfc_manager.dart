@JS()
library test.js;

import 'dart:async';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class NfcManagerPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'plugins.flutter.io/nfc_manager',
        const StandardMethodCodec(),
        registrar.messenger);
    final NfcManagerPlugin instance = NfcManagerPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);

    document.body!.append(ScriptElement()
      ..src =
          'assets/packages/nfc_manager_web/assets/test.js' // ignore: unsafe_html
      ..type = 'application/javascript'
      ..defer = true);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'Nfc#startSession':
        //final String url = call.arguments['url'];
        return _startNDEFReading();
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The nfc_manager plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  bool _startNDEFReading() {
    createNFCElementNew();
    return true;
    //return html.window.open('https://google.de', '') != null;
  }

  createNFCElement() {
    /*
    html.Element? ele = html.querySelector("#nfc");
    String content = """
      const ndef = new NDEFReader();
      ndef.scan().then(() => {
        console.log("Scan started successfully.");
        ndef.onreadingerror = () => {
          console.log("Cannot read data from the NFC tag. Try another one?");
        };
        ndef.onreading = event => {
          console.log("NDEF message read.");
        };
      }).catch(error => {
        console.log("Error! Scan failed to start: " + error);
      });
    """;
    if (html.querySelector("#nfc") != null) {
      ele!.remove();
    }
    final html.ScriptElement scriptText = html.ScriptElement()
      ..id = "nfc"
      ..innerHtml = content;
    html.querySelector('head')!.children.add(scriptText);
    */
  }

  createNFCElementNew() async {
    dynamic obj = await promiseToFuture(test());
    print(obj);
    document.on['fromJavascriptToDart'].listen((event) {
      print("HEY! I'M LISTENING!");
      MethodChannel('plugins.flutter.io/nfc_manager')
          .invokeMethod("onDiscovered", {
        "data": {"name": "sascha"},
        "handle": "hi"
      });
    });
  }
}

@JS()
external dynamic test();
