import 'dart:convert';
import 'package:access/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  User? user;

  UserService() {
    SharedPreferences.getInstance().then((prefs) {
      var userJson = prefs.getString("userinfo");
      print(userJson);
      this.user = User.fromJson(json.decode(userJson!));
    });
  }

  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    var boolSaved = await prefs.setString("userinfo", json.encode(user));
    if (boolSaved) this.user = user;
    return boolSaved;
  }

  @override
  List<Object> get props => [user!];
}
