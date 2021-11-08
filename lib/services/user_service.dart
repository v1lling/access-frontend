import 'dart:convert';
import 'package:access/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  User? user;

  Future<bool> initializeUserService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = await prefs.getString("userinfo");
    if (userJson != null) {
      this.user = User.fromJson(json.decode(userJson));
      return true;
    }
    return false;
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
