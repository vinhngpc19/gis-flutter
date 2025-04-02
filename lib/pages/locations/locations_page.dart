import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/common/app_bar/app_bar_custom.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';
import 'package:gis_disaster_flutter/pages/locations/locations_controller.dart';

class LocationsPage extends BaseScreen<LocationsController> {
  LocationsPage({super.key});
  @override
  Widget builder() {
    return Scaffold(
        appBar: AppBarCustom(titleAppBar: 'Tỉnh / Thành phố'),
        backgroundColor: color.backgroundColor,
        body: Obx(() => ListView.separated(
              padding: const EdgeInsets.only(bottom: 10),
              shrinkWrap: true,
              itemBuilder: (_, index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                  Get.find<HomeController>().handleTabController(
                      title: controller.listProvinces[index]);
                  // controller.getCoordinateProvince(
                  //     address: controller.listProvinces[index].name1 ?? '');
                },
                child: SizedBox(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        controller.listProvinces[index].name1 ?? '',
                        style: textStyle.regular(size: 14),
                      ),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, index) => appDivider(height: 0.5),
              itemCount: controller.listProvinces.length,
            )));
  }

  @override
  LocationsController? putController() => LocationsController();
}
