import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';

abstract class BaseWidget<T extends BaseController> extends StatelessWidget
    with BaseMixin {
  BaseWidget({this.tag, super.key}) {
    if (Get.isRegistered<T>()) {
      controller = GetInstance().find<T>();
    }
  }

  final String? tag;
  late final T controller;
  final BuildContext context = Get.context!;

  @override
  Widget build(BuildContext context) {
    return builder();
  }

  Widget builder();
}
