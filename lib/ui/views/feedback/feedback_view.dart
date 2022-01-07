import 'package:access/services/locale_service.dart';
import 'package:access/ui/views/feedback/feedback_viewmodel.dart';
import 'package:access/validators/userinfo_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedBackView extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final double paddingBetweenTextFields = 15;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var localeService = Provider.of<LocaleService>(context);

    return ViewModelBuilder<FeedbackViewModel>.reactive(
        builder: (BuildContext context, FeedbackViewModel model,
                Widget? child) =>
            Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                        color: Theme.of(context).canvasColor,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(AppLocalizations.of(context)!.feedback_title,
                                style: Theme.of(context).textTheme.headline2),
                            SizedBox(width: 32)
                          ],
                        )),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: paddingBetweenTextFields),

                                  //DEVICE
                                  TextFormField(
                                    autofocus: false,
                                    controller: model.deviceController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                      focusColor: Theme.of(context).canvasColor,
                                      labelText:
                                          AppLocalizations.of(context)!.device,
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).canvasColor),
                                      ),
                                    ),
                                    validator: (value) {
                                      return UserInfoValidator.validate(
                                          value,
                                          AppLocalizations.of(context)!.device,
                                          localeService.locale);
                                    },
                                  ),
                                  SizedBox(height: paddingBetweenTextFields),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8)),
                                      Expanded(
                                        child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .canvasColor),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .send),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                model.safeUserInfo(context);
                                              }
                                            }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => FeedbackViewModel());
  }
}
