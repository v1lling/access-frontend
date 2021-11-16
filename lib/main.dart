import 'dart:async';
import 'package:access/app/fluttify_router.router.dart';
import 'package:access/app/locator.dart';
import 'package:access/l10n/l10n.dart';
import 'package:access/services/dynamic_link_service.dart';
import 'package:access/services/locale_service.dart';
import 'package:access/services/theme_service.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/models/nfc_message.dart';
import 'package:flutter_nfc_plugin/models/nfc_state.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
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
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  var userService = locator<UserService>();

  InitializingApp(this.preferences);
  final StreamingSharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: userService.initializeUserService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: _dynamicLinkService.handleDynamicLinks(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return AccessApp();
                    default:
                      return Container();
                  }
                });
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
  /*
  NfcState? _nfcState;
  // NfcPlugin? nfcPlugin = NfcPlugin();
  StreamSubscription<NfcEvent>? _nfcMesageSubscription;
  String nfcState = 'Unknown';
  String nfcError = '';
  String nfcMessage = '';
  String nfcTechList = '';
  String nfcId = '';

  NfcMessage nfcMessageStartedWith = NfcMessage(payload: ["test"]);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    
    try {
      _nfcState = await nfcPlugin!.nfcState;
      print('NFC state is $_nfcState');
    } on PlatformException {
      print('Method "NFC state" exception was thrown');
    }


    try {
      final NfcEvent _nfcEventStartedWith = await nfcPlugin!.nfcStartedWith;
      print('NFC event started with is ${_nfcEventStartedWith.toString()}');
      if (_nfcEventStartedWith != null) {
        setState(() {
          nfcMessageStartedWith = _nfcEventStartedWith.message;
        });
      }
    } on PlatformException {
      print('Method "NFC event started with" exception was thrown');
    }

    if (_nfcState == NfcState.enabled) {
      _nfcMesageSubscription = nfcPlugin!.onNfcMessage.listen((NfcEvent event) {
        if (event.error.isNotEmpty) {
          setState(() {
            nfcMessage = 'ERROR: ${event.error}';
            nfcId = '';
          });
        } else {
          setState(() {
            nfcMessage = event.message.payload.toString();
            nfcTechList = event.message.techList.toString();
            nfcId = event.message.id;
          });
        }
      });
    }
  }

 */

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
            //    home: Container(child: Text('The app was started with an NFC:')),
            // navigatorKey: StackedService.navigatorKey,
            /*
                  routes: {
                    "/": (context) => LandingView(),
                    //"/checkin": (context) => CheckInView()
                  },
                */
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
