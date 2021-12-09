import 'package:access/main.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/material.dart';

class UriRoutingService {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final Widget? targetView = getViewFromUriString(settings.name!);
    return MaterialPageRoute(
        builder: (context) => targetView!, settings: settings);
  }

  Widget? getViewFromUriString(String? uriString) {
    if (uriString == null || uriString == "null") return LandingView();

    final Uri uri = Uri.parse(uriString);
    print("Navigating to: " + uri.path);
    switch (uri.path) {
      case "/checkin":
        String? roomId = uri.queryParameters["room"];
        if (roomId != null) {
          return CheckInView(roomId: roomId);
        } else {
          return LandingView();
        }
      case "/user":
        return UserInfoView();
      default:
        return LandingView();
    }
  }

  void navigateFromUri(String uri) {
    // get current path
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });

    Uri targetUri = Uri.dataFromString(uri);
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
