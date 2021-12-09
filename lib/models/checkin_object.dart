import 'package:access/models/user.dart';
import 'package:equatable/equatable.dart';

class CheckInObject extends Equatable {
  CheckInObject({this.userinfo, this.roomId, this.checkin, this.checkout});
  final User? userinfo;
  final String? roomId;
  final DateTime? checkin;
  final DateTime? checkout;

  factory CheckInObject.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return CheckInObject();
    final userinfo = json['userinfo'];
    final roomId = json['roomId'];
    final checkin = json['checkin'];
    final checkout = json['checkout'];

    return CheckInObject(
        userinfo: userinfo,
        roomId: roomId,
        checkin: checkin,
        checkout: checkout);
  }

  factory CheckInObject.empty() {
    return CheckInObject();
  }

  Map<String, dynamic> toJson() => {
        'userinfo': userinfo!.toJson(),
        'roomId': roomId,
        'checkin': checkin!
            .toIso8601String(), // json.encode(checkin, toEncodable: myEncode),
        "checkout": checkout!
            .toIso8601String(), // json.encode(checkout, toEncodable: myEncode),
      };

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  @override
  List<Object> get props => [userinfo!, roomId!, checkin!, checkout!];
}
