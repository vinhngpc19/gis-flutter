import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:gis_disaster_flutter/pages/dashboard/dashboard_page.dart';
import 'package:gis_disaster_flutter/pages/splash/splash_page.dart';

class AppRouter {
  static const String routerSplash = '/splash';
  static const String routerDashboard = '/dashboard';
  static const String routerHome = '/home';
  static const String routerLocations = '/locations';
  static const transitionDuration = Duration(milliseconds: 300);
  static const curve = Curves.fastOutSlowIn;
  static var transition = Transition.fadeIn;

  static List<GetPage> getPages = <GetPage>[
    GetPage<SplashPage>(
      name: routerSplash,
      page: () => SplashPage(),
      curve: curve,
      transitionDuration: transitionDuration,
    ),
    GetPage<DashboardPage>(
      name: routerDashboard,
      page: () => DashboardPage(),
      curve: curve,
      transitionDuration: transitionDuration,
    ),
  ];
}
