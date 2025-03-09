import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gis_disaster_flutter/global/app_base_color.dart';
import 'package:gis_disaster_flutter/global/app_theme_black.dart';
import 'package:gis_disaster_flutter/global/app_theme_light.dart';

enum AppThemeType { black, bright }

AppTheme appThemes = AppThemeBright();

abstract class AppTheme implements AppColor {
  ThemeData get theme;
}

class AppThemeBase {
  AppThemeBase() {
    _initThemeModeFromStorage();
  }

  static final Rx<AppThemeType> _appTheme = AppThemeType.bright.obs;

  AppThemeType get appTheme => _appTheme.value;

  AppTheme get theme =>
      appTheme != AppThemeType.black ? AppThemeBright() : AppThemeBlack();

  void _initThemeModeFromStorage() {
    // read from storage
  }

  static void changeAppTheme(AppThemeType appThemeType) =>
      saveThemeInStorage(appThemeType);

  static void saveThemeInStorage(AppThemeType type) {
    if (_appTheme.value != type) {
      _appTheme.value = type;
      // save in storage
    }
  }
}
