import 'package:access/ui/views/checkin/checkin_view.dart';
import 'package:access/ui/views/landing/landing_view.dart';
import 'package:stacked/stacked_annotations.dart';

// flutter packages pub run build_runner build

@StackedApp(
  routes: <StackedRoute<dynamic>>[
    MaterialRoute<dynamic>(page: LandingView),
    MaterialRoute<dynamic>(page: CheckInView),
  ],
)
class $FluttifyRouter {}
