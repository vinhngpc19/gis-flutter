import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';

class DashboardController extends BaseController {
  RxInt currentTabIndex = 0.obs;

  void changePageIndex({required int index}) async {
    if (index != currentTabIndex.value) {
      currentTabIndex.value = index;
    }
  }
}
