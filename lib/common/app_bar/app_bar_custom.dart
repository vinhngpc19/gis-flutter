import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/base/base_widget.dart';
import 'package:gis_disaster_flutter/global/app_theme_base.dart';

class AppBarCustom extends BaseWidget implements PreferredSizeWidget {
  AppBarCustom(
      {super.key,
      this.titleAppBar = '',
      this.widgetTitle,
      this.centerTitle = true,
      this.automaticallyImplyLeading = true,
      this.actions,
      this.leadingPressed,
      this.backgroundColor,
      this.leadingIcon,
      this.hideLeading = false,
      this.elevation = 0.5,
      this.bottom,
      this.actionTitleButton,
      this.actionButtonRadius = 10,
      this.actionPress,
      this.actionButtonPadding = 0,
      this.backIconColor,
      this.actionButtonWidth,
      this.marginRight = 14,
      this.titleSpacing});

  final String titleAppBar;
  final Widget? widgetTitle;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final String? actionTitleButton;
  final VoidCallback? leadingPressed;
  final Function()? actionPress;
  final String? leadingIcon;
  final Color? backgroundColor;
  final bool hideLeading;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final double actionButtonRadius;
  final double actionButtonPadding;
  final double? actionButtonWidth;
  final Color? backIconColor;
  final double? marginRight;
  final double? titleSpacing;
  @override
  Widget builder() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        scrolledUnderElevation: elevation,
        bottom: bottom,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              (Get.find<AppThemeBase>().appTheme == AppThemeType.bright)
                  ? Colors.white
                  : Colors.black,
          statusBarIconBrightness:
              (Get.find<AppThemeBase>().appTheme == AppThemeType.bright)
                  ? Brightness.dark
                  : Brightness.light,
        ),
        titleSpacing: titleSpacing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        surfaceTintColor: color.white,
        foregroundColor: color.white,
        actions: actionTitleButton != null
            ? <Widget>[
                // Center(
                //   child: WidgetButton(
                //     title: actionTitleButton!,
                //     onClick: actionPress!,
                //     textColor: color.white,
                //     borderColor: color.white,
                //     height: 30.h,
                //     width: actionButtonWidth,
                //     borderRadius: actionButtonRadius,
                //     padding: actionButtonPadding,
                //     margin: EdgeInsets.only(right: 14.r),
                //   ),
                // ),
              ]
            : <Widget>[
                ...actions ?? <Widget>[],
                SizedBox(width: marginRight),
              ],
        backgroundColor: backgroundColor ?? color.white,
        centerTitle: centerTitle,
        leading: _buildLeading(),
        elevation: elevation,
        leadingWidth: 50,
        shadowColor: const Color(0xFFEAEAEA),
        title: widgetTitle ??
            Text(
              titleAppBar,
              style: textStyle.extraBold(size: 22, color: color.black),
              maxLines: 2,
            ),
      ),
    );
  }

  Widget? _buildLeading() {
    if (!automaticallyImplyLeading) {
      return null;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (leadingPressed != null) {
          leadingPressed!();
        } else {
          Get.back();
        }
      },
      child: Icon(Icons.arrow_back_rounded, size: 30.0, color: color.mainColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
