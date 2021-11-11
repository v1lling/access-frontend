import 'package:access/ui/views/checkin/checkin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckInView extends StatelessWidget {
  CheckInView({this.roomId});

  final String? roomId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<CheckInViewModel>.reactive(
        builder: (BuildContext context, CheckInViewModel model,
                Widget? child) =>
            Scaffold(
              body: SafeArea(
                child: Container(
                  color: Theme.of(context).highlightColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          color: Theme.of(context).highlightColor, //,
                          height: size.height * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                    AppLocalizations.of(context)!.checkin +
                                        ": " +
                                        this.roomId!,
                                    style:
                                        Theme.of(context).textTheme.headline2),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 32, left: 24, right: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            /*
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(36),
                                  topLeft: Radius.circular(36))*/
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .userinfo,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            model.navigateToUserInfoView(
                                                context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  model.userService.user!
                                                          .givenname ??
                                                      "Unknown",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .copyWith(
                                                          color: model
                                                                      .userService
                                                                      .user!
                                                                      .givenname !=
                                                                  null
                                                              ? Colors.blue
                                                              : Colors.red)),
                                              SizedBox(width: 4),
                                              Icon(Icons.edit,
                                                  color: Colors.blue)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    //Check-Out Time
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .checkout_time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            model.selectCheckOutTime(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  DateFormat('kk:mm').format(
                                                      model.checkOutTime!),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .copyWith(
                                                          color: Colors.blue)),
                                              SizedBox(width: 4),
                                              Icon(Icons.edit,
                                                  color: Colors.blue)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Check-In Button
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: size.width * 0.5,
                                    height: 50,
                                    child: TextButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle),
                                            SizedBox(width: 8),
                                            Text(AppLocalizations.of(context)!
                                                .checkin),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor: model
                                                    .userService.user!
                                                    .isUserInfoComplete()
                                                ? MaterialStateProperty.all<
                                                    Color>(Colors.green)
                                                : MaterialStateProperty.all<
                                                    Color>(Colors.grey)),
                                        onPressed: model.userService.user!
                                                .isUserInfoComplete()
                                            ? model.checkInUser
                                            : null),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => CheckInViewModel(this.roomId));
  }
}
