import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';

mixin BaseCommonWidget {
  Divider appDivider({double height = 1, double thickness = 1}) {
    return Divider(
      height: height,
      color: appThemes.dividerColor,
      thickness: thickness,
    );
  }
}
