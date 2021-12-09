import 'package:access/ui/views/checkin/checkin_viewmodel.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckInView extends StatefulWidget {
  final String? roomId;
  CheckInView({String? roomId}) : roomId = roomId;
  @override
  _CheckInViewState createState() => new _CheckInViewState(roomId);
}

class _CheckInViewState extends State<CheckInView>
    with SingleTickerProviderStateMixin {
  _CheckInViewState(this.roomId);

  final String? roomId;
  late Animation<double> _animation = new Tween<double>(begin: 0, end: 1)
      .animate(new CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCirc));
  late AnimationController _animationController =
      _animationController = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));
    return ViewModelBuilder<CheckInViewModel>.reactive(
        builder: (BuildContext context, CheckInViewModel model,
                Widget? child) =>
            Scaffold(
              body: SafeArea(
                child: Container(
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
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LandingView()));
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(AppLocalizations.of(context)!.checkin,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    Text(this.roomId!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: size.width,
                          padding: const EdgeInsets.only(
                              top: 32, bottom: 38, left: 24, right: 24),
                          /*decoration: BoxDecoration(
                            color: Colors.white,
                            
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(36),
                                  topLeft: Radius.circular(36))
                          ),*/
                          child: !model.isCheckedIn! && !model.isLoading!
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                      .bodyText2),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
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
                                                        style: Theme
                                                                .of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                color: model
                                                                            .userService
                                                                            .user!
                                                                            .givenname !=
                                                                        null
                                                                    ? Theme.of(
                                                                            context)
                                                                        .canvasColor
                                                                    : Theme.of(
                                                                            context)
                                                                        .errorColor)),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.edit,
                                                        color: model
                                                                    .userService
                                                                    .user!
                                                                    .givenname !=
                                                                null
                                                            ? Theme.of(context)
                                                                .canvasColor
                                                            : Theme.of(context)
                                                                .errorColor)
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
                                                      .bodyText2),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                onPressed: () {
                                                  model.selectCheckOutTime(
                                                      context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        DateFormat('kk:mm')
                                                            .format(model
                                                                .checkOutTime!),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                color: model
                                                                        .isCheckoutTimeValid()
                                                                    ? Theme.of(
                                                                            context)
                                                                        .canvasColor
                                                                    : Theme.of(
                                                                            context)
                                                                        .errorColor)),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.edit,
                                                        color: model
                                                                .isCheckoutTimeValid()
                                                            ? Theme.of(context)
                                                                .canvasColor
                                                            : Theme.of(context)
                                                                .errorColor)
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
                                                  Text(AppLocalizations.of(
                                                          context)!
                                                      .checkin),
                                                ],
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          Colors.white),
                                                  backgroundColor: model
                                                              .userService.user!
                                                              .isUserInfoComplete() &&
                                                          model
                                                              .isCheckoutTimeValid()
                                                      ? MaterialStateProperty.all<Color>(
                                                          Theme.of(context)
                                                              .highlightColor)
                                                      : MaterialStateProperty.all<Color>(
                                                          Colors.grey)),
                                              onPressed: model.userService.user!
                                                      .isUserInfoComplete()
                                                  ? () {
                                                      model.checkInUser(
                                                          _animationController);
                                                    }
                                                  : null),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : model.isLoading!
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color:
                                              Theme.of(context).highlightColor))
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: Theme.of(context)
                                                  .highlightColor,
                                              width: 10,
                                            ),
                                          ),
                                          width: size.width / 2,
                                          height: size.width / 2,
                                          alignment: Alignment.center,
                                          child: model.isLoading!
                                              ? Container()
                                              : AnimatedCheck(
                                                  progress: _animation,
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                  size: size.width / 2,
                                                ),
                                        ),
                                        SizedBox(height: 30),
                                        Text(
                                            model.userCount.toString() +
                                                AppLocalizations.of(context)!
                                                    .personscheckedin,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2),
                                      ],
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => CheckInViewModel(this.roomId));
  }
}
