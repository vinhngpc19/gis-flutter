import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';
import 'package:google_fonts/google_fonts.dart';

import '../base/base_mixin.dart';

class AppThemeBlack extends AppTheme with BaseMixin {
  @override
  ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        appBarTheme: _buildAppBarTheme,
        bottomAppBarTheme: _buildBottomAppBarTheme,
        dialogTheme: _buildDialogTheme,
        textTheme: GoogleFonts.manropeTextTheme(),
      );
  AppBarTheme get _buildAppBarTheme => AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: mainColor),
      titleTextStyle: textStyle.regular(size: 16, color: color.white));

  BottomAppBarTheme get _buildBottomAppBarTheme => const BottomAppBarTheme(
        elevation: 0,
      );

  DialogTheme get _buildDialogTheme => const DialogTheme(elevation: 0);

  @override
  Color get mainColor => const Color(0xFF3A52EE);

  @override
  Color get black => const Color(0xFF000000);

  @override
  Color get white => const Color(0xFFFFFFFF);

  @override
  Color get backgroundColor => const Color(0xFF000000);

  @override
  Color get greyTextColor => const Color(0xFF666666);

  @override
  Color get dividerColor => const Color.fromARGB(255, 227, 226, 226);

  @override
  Color get redColor => Colors.red;
}
