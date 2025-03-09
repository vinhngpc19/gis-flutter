import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/pages/splash/splash_controller.dart';

class SplashPage extends BaseScreen<SplashController> {
  SplashPage({super.key});

  @override
  Widget builder() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  SplashController? putController() => SplashController();
}
