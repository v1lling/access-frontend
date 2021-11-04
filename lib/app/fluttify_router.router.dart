// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class Routes {
  static const String landingView = '/';
  static const String checkInView = '/checkin';

  static const all = <String>{landingView, checkInView};
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.checkInView, page: CheckInView),
    RouteDef(Routes.landingView, page: LandingView)
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    LandingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LandingView(),
        settings: data,
      );
    },
    CheckInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CheckInView(),
        settings: data,
      );
    },
  };
}
