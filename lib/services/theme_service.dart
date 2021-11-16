import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeService(bool? darkMode, {Color? color}) {
    _currentTheme = lightTheme;
    _currentDarkMode = false;
    /*
    if (darkMode!) {
      _currentTheme = darkTheme;
      _currentDarkMode = true;
    } else {
      _currentTheme = lightTheme;
      _currentDarkMode = false;
    }
    */
  }

  ThemeData? _currentTheme;
  bool? _currentDarkMode;

  ThemeData getTheme() => _currentTheme!;
  bool getDarkMode() {
    return _currentDarkMode!;
  }

  void setDarkMode(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentDarkMode = darkMode;
    prefs.setBool('darkMode', darkMode);
    if (darkMode) {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }
    notifyListeners();
  }

  static final ThemeData darkTheme = ThemeData.dark();

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Color(0xffd9e5ec),
    canvasColor: Color(0xff334152), //Color(0xff009b91),
    highlightColor: Color(0xff009b91),
    scaffoldBackgroundColor: Color(0xffd9e5ec),
    errorColor: Color(0xffA3320B),
    textTheme: TextTheme(
        button: const TextStyle(
            fontSize: 16, fontFamily: 'Montserrat', color: Colors.white),
        bodyText1: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal),
        bodyText2: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal),
        headline1: const TextStyle(
            color: Color(0xff334152),
            fontSize: 20.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
        headline2: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
        headline3: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800)),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        primary: Colors.white,
        // disabledMouseCursor: Colors.green,
        shadowColor: Colors.green,
      ),
    ),
  );
}
