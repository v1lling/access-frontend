import 'package:access/app/locator.dart';
import 'package:access/router/access_route_path.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:flutter/material.dart';

class AccessRouteInformationParser
    extends RouteInformationParser<AccessRoutePath> {
  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();
  @override
  Future<AccessRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.length == 0) return AccessRoutePath.home();

    final pageName = uri.pathSegments.elementAt(0).toString();
    if (uri.pathSegments.length == 1) {
      if (pageName != "user") return AccessRoutePath.home();
      return AccessRoutePath.user();
    }

    if (uri.pathSegments.length == 2) {
      String? roomId = uri.pathSegments.elementAt(1).toString();
      if (roomId.isEmpty || pageName != "checkin")
        return AccessRoutePath.home();
      bool isExisting = await _accessBackendService.getIsRoomExisting(roomId);
      if (!isExisting) return AccessRoutePath.home();
      return AccessRoutePath.checkin(roomId);
    }
    return AccessRoutePath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(AccessRoutePath homeRoutePath) {
    if (homeRoutePath.isHomePage) return RouteInformation(location: '/');
    if (homeRoutePath.isUserPage) return RouteInformation(location: '/user');
    if (homeRoutePath.isCheckinPage)
      return RouteInformation(location: '/checkin/${homeRoutePath.roomId}');

    return null;
  }
}
