import 'dart:convert';
import 'package:access/models/checkin_object.dart';
import 'package:access/models/user.dart';
import 'package:http/http.dart' as http;

class AccessBackendService {
  final String baseUrl = "access.netpy.de";
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<int> checkInUser(
      User user, String roomId, DateTime checkoutTime) async {
    CheckInObject checkin = CheckInObject(
        userinfo: user,
        roomId: roomId,
        checkin: DateTime.now(),
        checkout: checkoutTime);
    final response = await http.post(Uri.https(baseUrl, 'access/checkin'),
        body: jsonEncode(checkin.toJson()), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body)["usercount"];
    } else {
      print("Something went wrong");
      return -1;
    }
  }

  Future<int> checkInCount(String roomId) async {
    final response = await http.get(
        Uri.https(baseUrl, 'access/checkincount', {"roomId": roomId}),
        headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body)["usercount"];
    } else {
      print("Something went wrong");
      return -1;
    }
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
