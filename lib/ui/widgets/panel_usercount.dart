import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PanelUserCount extends StatelessWidget {
  final int? userCount;
  final String? roomId;
  PanelUserCount({this.userCount, this.roomId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.roomId ?? ""),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(this.userCount.toString(),
                      style: Theme.of(context).textTheme.headline5),
                  Text(AppLocalizations.of(context)!.usercount,
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
