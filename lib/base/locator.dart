import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:gis_disaster_flutter/base/loading_wrapper.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';

void setupLocator() {
  Get.put<LoadingController>(LoadingController());
  Get.put<AppThemeBase>(AppThemeBase());
}
