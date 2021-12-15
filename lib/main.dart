import 'dart:async';
import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
import 'package:access/services/uri_routing_service.dart';
import 'package:access/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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

  runApp(Phoenix(
    child: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeService(darkMode),
      ),
      ChangeNotifierProvider(create: (context) => LocaleService(Locale('en')))
    ], child: AccessApp(initialLink)),
  ));
}

class AccessApp extends StatelessWidget {
  final userService = locator<UserService>();
  final uriRoutingService = locator<UriRoutingService>();

  AccessApp(this.initialLink);
  final String? initialLink;

  @override
  Widget build(BuildContext context) {
    var localeService = Provider.of<LocaleService>(context);
    return StreamBuilder(
        stream: kIsWeb ? null : linkStream,
        builder: (context, linkSnapshot) {
          return FutureBuilder<bool>(
              future: userService.initializeUserService(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                        onGenerateRoute: uriRoutingService.generateRoute,
                        //  home: uriRoutingService.getViewFromUriString(
                        //    initialLink ?? linkSnapshot.data.toString(),),
                      );
                    },
                  );
                }
                return Container();
              });
        });
  }
}
