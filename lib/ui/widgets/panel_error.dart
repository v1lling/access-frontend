import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PanelError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.nfc_error1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1),
                  Text(AppLocalizations.of(context)!.nfc_error2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(height: 8),
                  Icon(Icons.error,
                      size: 100,
                      color: Theme.of(context).canvasColor.withOpacity(0.8)),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
