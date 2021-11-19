import 'dart:async';
import 'package:access/app/fluttify_router.router.dart';
import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_nfc_web/flutter_nfc_web.dart';
import 'package:flutter_nfc_web/js_ndef_record.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final preferences = await StreamingSharedPreferences.instance;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, // this one for android
      statusBarBrightness: Brightness.light // this one for iOS
      ));

  bool? darkMode = prefs.getBool('darkMode') ?? false;
  List<String?> language = <String?>[prefs.getString('locale')];

  runApp(Phoenix(
    child: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeService(darkMode),
      ),
      ChangeNotifierProvider(create: (context) => LocaleService(Locale('en')))
    ], child: InitializingApp(preferences)),
  ));
}

class InitializingApp extends StatelessWidget {
  var userService = locator<UserService>();

  InitializingApp(this.preferences);
  final StreamingSharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: userService.initializeUserService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AccessApp();
          }
          return Container();
        });
  }
}

class AccessApp extends StatefulWidget {
  @override
  _AccessAppState createState() => _AccessAppState();
}

class _AccessAppState extends State<AccessApp> {
  @override
  Widget build(BuildContext context) {
    var localeService = Provider.of<LocaleService>(context);

    return Consumer<ThemeService>(
      builder: (context, notifire, child) {
        return MaterialApp(
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
            initialRoute: "/",
            navigatorKey: navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute);
      },
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Uri settingsUri = Uri.parse(settings.name!);
    print("Navigating to: " + settingsUri.path);
    Widget? pageView;
    switch (settingsUri.path) {
      case "/checkin":
        String? roomId = settingsUri.queryParameters["room"];
        if (roomId != null) {
          pageView = CheckInView(roomId: roomId);
        } else {
          pageView = LandingView();
        }
        break;
      case "/user":
        pageView = UserInfoView();
        break;
      default:
        pageView = LandingView();
    }
    return MaterialPageRoute(
        builder: (context) => pageView!, settings: settings);
  }
}
