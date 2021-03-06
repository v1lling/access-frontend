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
                child: GestureDetector(
                  onTap: () {
                    // Workaround for Keyboard Bug on iOS Safari
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      currentFocus.focusedChild!.unfocus();
                    }
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                            color: Theme.of(context).canvasColor,
                            height: size.height * 0.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    model.userService.user!.isUserInfoComplete()
                                        ? "Hi " +
                                            model.userService.user!.givenname! +
                                            "!"
                                        : AppLocalizations.of(context)!
                                            .userinfo_headline,
                                    style:
                                        Theme.of(context).textTheme.headline2),
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

                            /*decoration: 
                            BoxDecoration(
                              color: Color(0xffd9e5ec),
                              /*
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(36),
                                    topLeft: Radius.circular(36))
                                    */
                            ),
                            */
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            color:
                                                Theme.of(context).canvasColor)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => LandingViewModel());
  }
}
