import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_strategy/url_strategy.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future main() async {
  setupLocator();
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, // this one for android
      statusBarBrightness: Brightness.light // this one for iOS
      ));

  bool? darkMode = prefs.getBool('darkMode') ?? false;
  final String? initialLink = kIsWeb ? null : await getInitialLink();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeService(darkMode),
    ),
    ChangeNotifierProvider(create: (context) => LocaleService(Locale('en')))
  ], child: AccessApp(initialLink)));
}

class AccessApp extends StatefulWidget {
  final String? initalLink;
  AccessApp(String? initalLink) : initalLink = initalLink;
  @override
  State<StatefulWidget> createState() => _AccessAppState(initalLink);
}

class _AccessAppState extends State<AccessApp> {
  AccessRouterDelegate _routerDelegate = AccessRouterDelegate();
  AccessRouteInformationParser _routeInformationParser =
      AccessRouteInformationParser();

  _AccessAppState(this.initialLink);
  final String? initialLink;

  @override
  Widget build(BuildContext context) {
    var localeService = Provider.of<LocaleService>(context);
    return StreamBuilder(
      stream: kIsWeb ? null : linkStream,
      builder: (context, linkSnapshot) {
        return Consumer<ThemeService>(
          builder: (context, notifire, child) {
            return MaterialApp.router(
              locale: localeService.locale,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              title: 'Access',
              theme: notifire.getTheme(),
              routerDelegate: _routerDelegate,
              routeInformationParser: _routeInformationParser,
            );
          },
        );
      },
    );
  }
}

class AccessRoutePath {
  final String? roomId;
  final bool? isUser;

  AccessRoutePath.home()
      : roomId = null,
        isUser = false;
  AccessRoutePath.checkin(this.roomId) : isUser = false;
  AccessRoutePath.user()
      : roomId = null,
        isUser = true;

  bool get isHomePage => roomId == null && isUser == false;
  bool get isCheckinPage => roomId != null;
  bool get isUserPage => roomId == null && isUser == true;
}

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
}
