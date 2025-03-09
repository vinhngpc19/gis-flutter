import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';

class CircleLoading extends StatelessWidget with BaseMixin {
  const CircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color.mainColor,
    );
  }
}
