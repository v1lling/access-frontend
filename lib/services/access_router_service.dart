import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class AccessRouterService {
  FluroRouter router = FluroRouter();
  static Handler _checkinHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    print("doing it");
    return CheckInView(roomId: params['id']?[0]);
  });
  static Handler _homehandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          LandingView());
  void setupRouter() {
    print("is setup");
    router.define(
      '/',
      handler: _homehandler,
    );
    router.define(
      '/checkin/:id',
      handler: _checkinHandler,
    );
  }
}
