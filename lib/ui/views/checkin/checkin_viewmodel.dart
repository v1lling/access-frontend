import 'package:access/app/locator.dart';
import 'package:access/services/access_backend_service.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:stacked/stacked.dart';

class CheckInViewModel extends BaseViewModel {
  final AccessBackendService _accessBackendService =
      locator<AccessBackendService>();
  final UserService userService = locator<UserService>();
  String? roomId;
  bool? isCheckedIn = false;
  int? userCount = 0;
  bool? isLoading = false;

  DateTime? checkOutTime = DateTime.now().add(Duration(minutes: 90));

  CheckInViewModel(String? roomId) {
    this.roomId = roomId;
  }

  @override
  void dispose() {
    //_timer!.cancel();
    super.dispose();
  }

  void checkInUser(AnimationController _animationController) async {
    if (userService.user != null) {
      this.isLoading = true;
      notifyListeners();

      this.userCount = await _accessBackendService.checkInUser(
          userService.user!, this.roomId!, this.checkOutTime!);
      this.isLoading = false;
      if (this.userCount != -1) {
        this.isCheckedIn = true;
        _animationController.forward();
      }
      notifyListeners();
    }
  }

  void navigateToUserInfoView(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserInfoView()))
        .then((_) {
      notifyListeners();
    });
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

  bool isCheckoutTimeValid() {
    return this.checkOutTime!.compareTo(DateTime.now()) > 0;
  }
}
