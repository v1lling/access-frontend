import 'package:flutter/cupertino.dart';

class UserInfoValidator {
  static String? validate(String? value, String label, Locale? locale) {
    print(value);
    return value == null || value.isEmpty
        ? (locale!.languageCode == 'de'
            ? 'Bitte geben Sie ihren ' + label + ' an'
            : 'Please fill in your ' + label.toLowerCase())
        : null;
  }
}
