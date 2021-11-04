import 'dart:io';
import 'dart:async';
import 'package:access/app/fluttify_router.router.dart';
import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/services/dynamic_link_service.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final preferences = await StreamingSharedPreferences.instance;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  bool? darkMode = prefs.getBool('darkMode') ?? false;
  List<String?> language = <String?>[prefs.getString('locale')];

  runApp(Phoenix(
    child: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeService(darkMode),
      ),
      ChangeNotifierProvider(
          create: (context) => LocaleService(language[0] == null
              ? (!(Platform.localeName.split('_')[0] == 'en' ||
                      Platform.localeName.split('_')[0] == 'de')
                  ? Locale('en')
                  : Locale(Platform.localeName.split('_')[0]))
              : Locale(language[0]!)))
    ], child: Fluttify(preferences)),
  ));
}

class Fluttify extends StatelessWidget {
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  Fluttify(this.preferences);
  final StreamingSharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dynamicLinkService.handleDynamicLinks(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return App(preferences);
            default:
              return Container();
          }
        });
  }
}

class App extends StatelessWidget {
  App(this.preferences);
  final StreamingSharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    var localeService = Provider.of<LocaleService>(context);
    return PreferenceBuilder<String>(
      preference: preferences.getString('token', defaultValue: ""),
      builder: (BuildContext context, String token) {
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
              initialRoute: Routes.landingView,
              navigatorKey: StackedService.navigatorKey,
              onGenerateRoute: StackedRouter().onGenerateRoute,
            );
          },
        );
      },
    );
  }
}
