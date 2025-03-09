// import 'package:flutter/material.dart';
// import 'package:gis_disaster_flutter/base/base_mixin.dart';

// class MainButton extends StatelessWidget with BaseMixin {
//   const MainButton(
//       {super.key,
//       required this.onPressed,
//       this.bgColor,
//       this.textColor,
//       this.textSize,
//       required this.title,
//       this.padding,
//       this.height = 50.0,
//       this.borderRadius = 50,
//       this.prefixIcon,
//       this.hasBorder = true,
//       this.borderColor});

//   final Function() onPressed;
//   final EdgeInsets? padding;
//   final String? prefixIcon;
//   final bool hasBorder;
//   final double height;
//   final Color? bgColor;
//   final Color? textColor;
//   final double borderRadius;
//   final double? textSize;
//   final String title;
//   final Color? borderColor;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: padding ?? EdgeInsets.zero,
//         child: SizedBox(
//           height: 50,
//           child: ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//               elevation: 0.0,
//               backgroundColor: bgColor ?? color.mainColor,
//               shadowColor: Col