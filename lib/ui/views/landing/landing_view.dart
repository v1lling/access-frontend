import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_viewmodel.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<LandingViewModel>.reactive(
        builder: (BuildContext context, LandingViewModel model,
                Widget? child) =>
            Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).highlightColor,
                child: Icon(Icons.nfc),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CheckInView(roomId: "F-102")));
                },
              ),
              body: SafeArea(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          color: Theme.of(context).primaryColor, //,
                          height: size.height * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Hi Sascha!',
                                  style: Theme.of(context).textTheme.headline2),
                              IconButton(
                                  icon: Icon(Icons.edit,
                                      size: 20, color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserInfoView()));
                                  })
                            ],
                          )),
                      Expanded(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(36),
                                  topLeft: Radius.circular(36))),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/hand.png',
                                width: 300.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                              ),
                              Text(AppLocalizations.of(context)!.landing,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => LandingViewModel());
  }
}
