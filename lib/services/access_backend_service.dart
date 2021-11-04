import 'dart:convert';
import 'package:access/models/user.dart';
import 'package:http/http.dart' as http;

class AccessBackendService {
  final String baseUrl = "access.netpy.de";

  Future<bool> checkInUser(
      User user, String roomId, DateTime checkoutTime) async {
    var payload = {};
    payload['userinfo'] = json.encode(user);
    payload['roomId'] = json.encode(roomId);
    payload['checkin'] = json.encode(DateTime.now(), toEncodable: myEncode);
    payload['checkout'] = json.encode(checkoutTime, toEncodable: myEncode);
    final response = await http.post(Uri.https(baseUrl, 'access/checkin'),
        body: json.encode(payload));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Something went wrong");
      return false;
    }
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
