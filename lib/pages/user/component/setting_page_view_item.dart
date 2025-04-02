import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';

class SettingPageViewItem extends StatelessWidget with BaseMixin {
  SettingPageViewItem({
    required this.icon,
    required this.label,
    this.value = "",
    this.line = true,
    super.key,
    required this.onTap,
  });

  final String icon;
  final String label;
  final String value;
  final bool line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              color: color.backgroundColor,
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: textStyle.medium(size: 16, color: color.black),
                    ),
                  ),
                  value == ""
                      ? const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        )
                      : Text(
                          value,
                          style:
                              textStyle.semiBold(size: 14, color: color.black),
                        ),
                ],
              ),
            ),
            line == true
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 48),
                      width: double.infinity,
                      height: 1,
                      color: const Color(0XFFCCCCCC),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
