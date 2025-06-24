// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/loading_wrapper.dart';
import 'package:gis_disaster_flutter/base/locator.dart';
import 'package:gis_disaster_flutter/data/model/user.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('user');

  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: (Get.find<AppThemeBase>().appTheme == AppThemeType.bright)
        ? Colors.white
        : Colors.black,
    statusBarIconBrightness:
        (Get.find<AppThemeBase>().appTheme == AppThemeType.bright)
            ? Brightness.dark
            : Brightness.light,
    systemNavigationBarColor:
        (Get.find<AppThemeBase>().appTheme == AppThemeType.bright)
            ? Colors.white
            : Colors.black,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VDIsaster',
      debugShowCheckedModeBanner: false,
      getPages: AppRouter.getPages,
      initialRoute: AppRouter.routerDashboard,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) => LoadingWrapper(child: child),
    );
  }
}
