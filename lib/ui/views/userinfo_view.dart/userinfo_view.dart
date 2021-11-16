import 'package:access/services/locale_service.dart';
import 'package:access/ui/views/userinfo_view.dart/userinfo_viewmodel.dart';
import 'package:access/validators/userinfo_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final double paddingBetweenTextFields = 15;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserInfoViewModel>.reactive(
        builder: (BuildContext context, UserInfoViewModel model,
                Widget? child) =>
            FutureBuilder(
                future: model.fillUserInfo(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      var localeService = Provider.of<LocaleService>(context);

                      return Scaffold(
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0, vertical: 32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //HEADLINE
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .userinfo_headline,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      SizedBox(
                                          height: paddingBetweenTextFields),

                                      //FIRSTNAME
                                      TextFormField(
                                        autofillHints: [
                                          AutofillHints.givenName
                                        ],
                                        autofocus: false,
                                        controller: model.givennameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .givenname,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .givenname,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      //LASTNAME
                                      TextFormField(
                                        autofocus: false,
                                        autofillHints: [
                                          AutofillHints.familyName
                                        ],
                                        controller: model.familynameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .familyname,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .familyname,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      //STREET
                                      TextFormField(
                                        autofocus: false,
                                        autofillHints: [
                                          AutofillHints.streetAddressLine1
                                        ],
                                        controller: model.streetController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .street,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .street,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      //POSTAL CODE
                                      TextFormField(
                                        autofocus: false,
                                        autofillHints: [
                                          AutofillHints.postalCode
                                        ],
                                        controller: model.postalcodeController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .postalcode,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .postalcode,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      //TOWN
                                      TextFormField(
                                        autofocus: false,
                                        autofillHints: [
                                          AutofillHints.streetAddressLevel2
                                        ],
                                        controller: model.townController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .town,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .town,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      //MOBILE NUMBER
                                      TextFormField(
                                        autofocus: false,
                                        autofillHints: [
                                          AutofillHints.telephoneNumber
                                        ],
                                        controller:
                                            model.mobilenumberController,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                          focusColor:
                                              Theme.of(context).canvasColor,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .mobilenumber,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                          ),
                                        ),
                                        validator: (value) {
                                          return UserInfoValidator.validate(
                                              value,
                                              AppLocalizations.of(context)!
                                                  .mobilenumber,
                                              localeService.locale);
                                        },
                                      ),
                                      SizedBox(
                                          height: paddingBetweenTextFields),
                                      SizedBox(
                                          height: paddingBetweenTextFields),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.grey),
                                                ),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .cancel),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .save),
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
                      );
                  }
                }),
        viewModelBuilder: () => UserInfoViewModel());
  }
}
