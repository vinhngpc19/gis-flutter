import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class HomePage extends BaseScreen<HomeController> {
  HomePage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: MapWidget(
        onMapCreated: controller.onMapCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        },
        cameraOptions: CameraOptions(
            zoom: 4.0,
            center: Point(coordinates: Position(lngVietnamPos, latVietnamPos))),
      ),
    );
  }

  @override
  HomeController? putController() => HomeController();
}
