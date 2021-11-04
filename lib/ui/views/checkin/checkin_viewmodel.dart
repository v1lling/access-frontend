import 'package:access/app/locator.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:stacked/stacked.dart';

class CheckInViewModel extends BaseViewModel {
  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();
  final UserService userService = locator<UserService>();
  String? roomId;

  DateTime? checkOutTime = DateTime.now().add(Duration(minutes: 90));

  CheckInViewModel(String? roomId) {
    this.roomId = roomId;
  }

  void checkInUser() async {
    if (userService.user != null) {
      await _accessBackendService.checkInUser(
          userService.user!, this.roomId!, this.checkOutTime!);
    }
  }

  void selectCheckOutTime(BuildContext context) {
    DatePicker.showTimePicker(context,
        showTitleActions: true, showSecondsColumn: false, onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      checkOutTime = date;
      notifyListeners();
    }, currentTime: DateTime.now().add(Duration(minutes: 90)));
  }
}
