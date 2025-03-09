import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/duration_extensions.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:gis_disaster_flutter/base/loading_wrapper.dart';

abstract class BaseController extends GetxController {
  LoadingController get loadingController => Get.find<LoadingController>();

  @override
  void onInit() {
    hideKeyBoard();
    super.onInit();
  }

  void hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> hideLoading() async {
    await 0.01.seconds.delay();
    loadingController.hide();
  }

  Future<void> showLoading() async {
    await 0.01.seconds.delay();
    hideKeyBoard();
    loadingController.show();
  }

  @override
  void dispose() {
    loadingController.hide();
    hideKeyBoard();
    super.dispose();
  }
}
