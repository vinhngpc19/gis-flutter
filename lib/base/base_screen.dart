import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gis_disaster_flutter/base/base_common_widget.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';
import 'package:gis_disaster_flutter/base/loading_wrapper.dart';

abstract class BaseScreen<T extends GetxController> extends StatelessWidget
    with BaseMixin, BaseCommonWidget {
  BaseScreen({super.key}) {
    setController();
  }
  late final T controller;
  T? putController();

  void setController() {
    if (putController() != null && !Get.isRegistered<T>()) {
      if (T != LoadingController) {
        controller = Get.put<T>(putController()!);
      }
    } else {
      controller = Get.find<T>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loadingController = Get.find<LoadingController>().loadingCtrl.value;
      return PopScope(
          canPop: !loadingController,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: builder(),
          ));
    });
  }

  Widget builder();
}
