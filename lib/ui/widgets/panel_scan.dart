import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PanelScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.readytoscan,
              style: Theme.of(context).textTheme.headline4),
          Icon(Icons.contactless_outlined,
              size: 100, color: Theme.of(context).canvasColor.withOpacity(0.8)),
          Text(AppLocalizations.of(context)!.holdnear,
              style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }
}
