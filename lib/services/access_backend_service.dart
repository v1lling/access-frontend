import 'dart:convert';
import 'package:access/models/checkin_object.dart';
import 'package:access/models/user.dart';
import 'package:http/http.dart' as http;

class AccessBackendService {
  final String baseUrl = "access.netpy.de";
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<bool> createRoom(String roomId) async {
    final response = await http.put(Uri.https(baseUrl, 'access/createroom'),
        body: jsonEncode({"roomId": roomId}), headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Something went wrong");
      return false;
    }
  }

  Future<bool> getIsRoomExisting(String? roomId) async {
    final response = await http.get(
        Uri.https(baseUrl, 'access/checkroom', {"roomId": roomId}),
        headers: headers);
    if (response.statusCode == 200) {
      return response.body == "true";
    } else {
      print("Something went wrong");
      return false;
    }
  }

  Future<int> checkInUser(
      User user, String roomId, DateTime checkoutTime) async {
    CheckInObject checkin = CheckInObject(
        userinfo: user,
        roomId: roomId,
        checkin: DateTime.now(),
        checkout: checkoutTime);
    final response = await http.put(Uri.https(baseUrl, 'access/checkin'),
        body: jsonEncode(checkin.toJson()), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body)["usercount"];
    } else {
      print("Something went wrong");
      return -1;
    }
  }

  Future<void> sendFeedback(dynamic feedback) async {
    final response = await http.put(Uri.https(baseUrl, 'access/feedback'),
        body: jsonEncode(feedback), headers: headers);
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
