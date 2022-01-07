import 'package:access/router/access_route_information_parser.dart';
import 'package:access/router/access_route_path.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/material.dart';

class AccessRouterDelegate extends RouterDelegate<AccessRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AccessRoutePath> {
  String? _roomId;
  bool? _isUser;

  final GlobalKey<NavigatorState> navigatorKey;
  AccessRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AccessRoutePath get currentConfiguration {
    return _isUser == true
        ? AccessRoutePath.user()
        : _roomId == null
            ? AccessRoutePath.home()
            : AccessRoutePath.checkin(_roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
            key: LandingView.valueKey,
            child: LandingView(
                onCheckinScanned: _handleCheckinScanned,
                onUserTapped: _handleUserTapped)),
        if (_roomId != null)
          MaterialPage(
              key: CheckInView.valueKey, child: CheckInView(roomId: _roomId)),
        if (_isUser == true)
          MaterialPage(key: UserInfoView.valueKey, child: UserInfoView())
      ],
      onPopPage: (route, result) {
        final page = route.settings as MaterialPage;
        if (!route.didPop(result)) {
          return false;
        }
        if (page.key == CheckInView.valueKey) {
          _roomId = null;
        }
        if (page.key == UserInfoView.valueKey) {
          _isUser = false;
        }
        notifyListeners();
        return true;
      },
    );
  }

  void _handleCheckinScanned(String? roomId) {
    _roomId = roomId;
    notifyListeners();
  }

  void _handleUserTapped() {
    _isUser = true;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AccessRoutePath path) async {
    if (path.isCheckinPage) {
      _isUser = false;
      if (path.roomId == null) {
        _roomId = null;
        return;
      }
      _roomId = path.roomId;
    } else if (path.isUserPage) {
      _isUser = true;
      _roomId = null;
    } else {
      _isUser = false;
      _roomId = null;
    }
  }

  Future<void> parseRoute(Uri? uri) async {
    try {
      AccessRouteInformationParser _routeInformationParser =
          AccessRouteInformationParser();
      AccessRoutePath targetPath = await _routeInformationParser
          .parseRouteInformation(RouteInformation(location: uri!.path));
      await setNewRoutePath(targetPath);
      notifyListeners();
    } catch (e) {
      AccessBackendService().createRoom(e.toString());
    }
  }
}
