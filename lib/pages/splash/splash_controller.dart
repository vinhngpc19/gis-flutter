import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    _moveToScreen();
    super.onInit();
  }

  Future<void> _moveToScreen() async {
    await 1.seconds.delay();
    Get.offAllNamed(AppRouter.routerDashboard);
  }
}
