import 'dart:async';
import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/router/access_route_information_parser.dart';
import 'package:access/router/access_router_delegate.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeService(darkMode),
    ),
    ChangeNotifierProvider(create: (context) => LocaleService(Locale('en')))
  ], child: AccessApp()));
}

class AccessApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccessAppState();
}

class _AccessAppState extends State<AccessApp> {
  AccessRouterDelegate _routerDelegate = AccessRouterDelegate();
  AccessRouteInformationParser _routeInformationParser =
      AccessRouteInformationParser();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // only handle deep links on mobile
    if (!kIsWeb) initialize();
  }

  String? uri = "haha";

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    try {
      // app was closed
      final Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        _routerDelegate.parseRoute(initialUri);
      }
    } on FormatException catch (error) {
      print(error);
    }
    // app was in background
    _linkSubscription = uriLinkStream.listen((Uri? uri) async {
      if (!mounted) return;
      _routerDelegate.parseRoute(uri);
    }, onError: (error) => print(error));
  }

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
