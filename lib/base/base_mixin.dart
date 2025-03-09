import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gis_disaster_flutter/global/app_text_style.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';

mixin BaseMixin {
  AppTheme get color => Get.find<AppThemeBase>().theme;

  AppTextStyle get textStyle => AppTextStyle.share;
}
