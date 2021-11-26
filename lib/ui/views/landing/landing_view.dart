import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_viewmodel.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_view.dart';
import 'package:access/ui/widgets/landing_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_web/flutter_nfc_web.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
              body: SafeArea(
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
                                      ? "Hi, " +
                                          model.userService.user!.givenname! +
                                          "!"
                                      : AppLocalizations.of(context)!
                                          .userinfo_enter,
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
                        child: !model.isNfcAvailable! ||
                                model.nfcPermission != "prompt" ||
                                model.nfcPermission != "granted"
                            ? Container()
                            : SlidingUpPanel(
                                controller: model.panelController,
                                backdropEnabled: true,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0),
                                ),
                                panel: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        model.panelContent,
                                        SizedBox(height: 20),
                                        Container(
                                          width: size.width,
                                          height: 50,
                                          child: TextButton(
                                            onPressed: () {
                                              model.panelController.close();
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .close),
                                            style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.grey)),
                                          ),
                                        ),
                                      ],
                                    )),
                                minHeight: 0,
                                maxHeight: size.height / 2,
                                body: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  width: size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      LandingActionButton(
                                          title: "Check-In",
                                          icon: Icons.check,
                                          onTap: model.activateNFCScan),
                                      SizedBox(height: 8),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(height: 8),
                                      LandingActionButton(
                                          title: AppLocalizations.of(context)!
                                              .get_checkins,
                                          icon: Icons.people_sharp,
                                          onTap: model.writeNFC),
                                      SizedBox(height: 8),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(height: 8),
                                      LandingActionButton(
                                          title: AppLocalizations.of(context)!
                                              .create_nfc_tag,
                                          icon: Icons.contactless_outlined,
                                          onTap: model.startNFCWrite),
                                    ],
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => LandingViewModel());
  }
}

class LandingAction {}
