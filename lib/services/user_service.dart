import 'dart:convert';
import 'dart:math';
import 'package:access/models/user.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faker_dart/src/utils/locale_utils.dart';
import 'package:stacked/stacked.dart';

class UserService with ReactiveServiceMixin {
  ReactiveValue<User> _user = ReactiveValue<User>(User.empty());
  final faker = Faker.instance;

  ReactiveValue<User> get user => _user;

  UserService() {
    listenToReactiveValues([user]);
    initializeUserService();
  }

  Future<bool> initializeUserService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = await prefs.getString("userinfo");
    if (userJson != null) {
      var user = User.fromJson(json.decode(userJson));
      this._user.value = user;
      return true;
    } else {
      faker.setLocale(FakerLocaleType.de);

      var randomizer = new Random();
      User randomUser = User(
          givenname: faker.name.firstName(),
          familyname: faker.name.lastName(),
          street: faker.address.streetName() + " 1",
          postalcode: (10000 + randomizer.nextInt(99999 - 10000))
              .toString(), //faker.address.zipCode(),
          town: faker.address.city(),
          mobilenumber: '+49172 123456');
      this.saveUser(randomUser);
      return false;
    }
  }

  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    var boolSaved = await prefs.setString("userinfo", json.encode(user));
    if (boolSaved) this._user.value = user;
    return boolSaved;
  }
}
