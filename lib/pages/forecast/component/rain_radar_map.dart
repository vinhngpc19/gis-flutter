import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:gis_disaster_flutter/base/base_widget.dart';

class RainRadarMap extends BaseWidget {
  final Function(mb.MapboxMap) onMapCreated;
  final mb.CameraOptions cameraOptions;

  RainRadarMap({
    super.key,
    required this.onMapCreated,
    required this.cameraOptions,
  });

  @override
  Widget builder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: mb.MapWidget(
          onMapCreated: onMapCreated,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())
          },
          cameraOptions: cameraOptions,
        ),
      ),
    );
  }
}
