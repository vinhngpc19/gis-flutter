import 'package:flutter/material.dart';

class AppTextStyle {
  static final AppTextStyle share = AppTextStyle();

  TextStyle extraBold({
    double? size,
    Color? color,
    Color? backgroundColor,
    double? height,
  }) =>
      custom(
        size: size,
        color: color,
        fontWeight: FontWeight.w800,
        height: height,
      );

  TextStyle bold({
    double? size,
    Color? color,
    Color? backgroundColor,
    double? height,
    TextDecoration? decoration,
  }) =>
      custom(
        size: size,
        color: color,
        fontWeight: FontWeight.w700,
        height: height,
        decoration: decoration,
      );

  TextStyle semiBold({
    double? size,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? height,
  }) =>
      custom(
        size: size,
        color: color,
        fontWeight: FontWeight.w600,
        decoration: decoration,
        fontStyle: fontStyle,
        height: height,
      );
  TextStyle medium({
    double? size,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? height,
  }) =>
      custom(
        size: size,
        color: color,
        fontWeight: FontWeight.w500,
        decoration: decoration,
        fontStyle: fontStyle,
        height: height,
      );

  TextStyle regular({
    double? size,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? height,
  }) =>
      custom(
        size: size,
        color: color,
        fontWeight: FontWeight.w400,
        decoration: decoration,
        fontStyle: fontStyle,
        height: height,
      );

  TextStyle custom({
    double? size,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: (size ?? 14),
      color: color ?? Colors.black,
      height: height ?? 1.2,
      decoration: decoration,
      fontFeatures: const <FontFeature>[
        FontFeature.tabularFigures(),
      ],
    );
  }
}
