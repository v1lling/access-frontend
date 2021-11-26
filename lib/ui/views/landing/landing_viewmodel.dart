import 'package:access/app/locator.dart';
import 'package:access/services/user_service.dart';
import 'package:access/ui/widgets/panel_scan.dart';
import 'package:access/ui/widgets/panel_success.dart';
import 'package:access/ui/widgets/panel_usercount.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';

class LandingViewModel extends BaseViewModel {
  UserService userService = locator<UserService>();
  final PanelController panelController = PanelController();
  Widget panelContent = Container();

  void startNFCWrite() {
    panelContent = PanelScan();
    notifyListeners();
    panelController.open();
    new Future.delayed(const Duration(milliseconds: 1000), () {
      //panelContent = PanelUserCount(roomId: "Test", userCount: 3);
      //panelContent = PanelSuccess();
      notifyListeners();
    });
  }
}
