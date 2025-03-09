import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/locator.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  setupLocator();
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
      initialRoute: AppRouter.routerSplash,
    );
  }
}
