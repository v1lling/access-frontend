import 'package:access/ui/views/checkin/checkin_viewmodel.dart';
import 'package:flutter/material.dart';
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
                                    AppLocalizations.of(context)!.checkin,
                                    style:
                                        Theme.of(context).textTheme.headline2),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(36),
                                  topLeft: Radius.circular(36))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(this.roomId!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    SizedBox(height: 30),
                                    //Check-Out Time
                                    Text(
                                        AppLocalizations.of(context)!
                                            .checkout_time,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    TextButton(
                                      onPressed: () {
                                        model.selectCheckOutTime(context);
                                      },
                                      child: Text(
                                          model.checkOutTime!.hour.toString() +
                                              ":" +
                                              model.checkOutTime!.minute
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(color: Colors.blue)),
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
                                            backgroundColor:
                                                model.userService.user !=
                                                        null
                                                    ? MaterialStateProperty.all<
                                                        Color>(Colors.green)
                                                    : MaterialStateProperty.all<
                                                        Color>(Colors.grey)),
                                        onPressed:
                                            model.userService.user != null
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
