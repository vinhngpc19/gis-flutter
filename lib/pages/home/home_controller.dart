// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:gis_disaster_flutter/base/base_controller.dart';
// import 'package:gis_disaster_flutter/data/use_case/mock_disaster_use_case.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// const double lngVietnamPos = 105.806692;
// const double latVietnamPos = 15.903061;

// class HomeController extends BaseController {
//   final _useCase = MockDisasterUseCase();

//   MapboxMap? mapboxMap;
//   PolylineAnnotationManager? polylineAnnotationManager;
//   CircleAnnotationManager? circleAnnotationManager;

//   final RxList<FeatureData> listFloodFeatures = <FeatureData>[].obs;
//   final polylineOptions = <PolylineAnnotationOptions>[];

//   void onMapCreated(MapboxMap mapboxMap) {
//     this.mapboxMap = mapboxMap;
//     mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
//     mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
//     mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
//     // reference my polylineAnnotationManager to 'value'
//     mapboxMap.annotations
//         .createPolylineAnnotationManager()
//         .then((value) => polylineAnnotationManager = value);
//     mapboxMap.annotations
//         .createCircleAnnotationManager()
//         .then((value) => circleAnnotationManager = value);
//   }

//   Future<void> getPolylineAndMarker({required Province province}) async {
//     _useCase.getPolygon(
//         provinces: province.name1 ?? '',
//         onSuccess: (data) async {
//           await _drawNewPolylines(data);
//           _flyToPos(Position(province.position![0], province.position![1]));
//           //
//           if (province.name1 == "Thừa Thiên Huế") {
//             await _getMockFloods();
//           }
//         });
//   }

//   Future<void> _drawNewPolylines(FeaturePolygon polygon) async {
//     _clearAnnotations();

//     final coordinates = polygon.geometry?.coordinates;
//     if (coordinates.length == 1) {
//       _addPolylineOptions(coordinates);
//     } else {
//       for (final coordinate in coordinates) {
//         _addPolylineOptions(coordinate);
//       }
//     }
//     if (polylineOptions.isNotEmpty) {
//       polylineOptions.length == 1
//           ? await polylineAnnotationManager?.create(polylineOptions[0])
//           : await polylineAnnotationManager?.createMulti(polylineOptions);
//     }
//   }

//   void _addPolylineOptions(dynamic coordinates) {
//     final tempList = coordinates[0];
//     polylineOptions.add(PolylineAnnotationOptions(
//         geometry: LineString(
//             coordinates: List<Position>.generate((tempList as List).length,
//                 (index) => Position(tempList[index][0], tempList[index][1]))),
//         lineWidth: 1.5,
//         lineGapWidth: 0.0,
//         lineColor: const Color(0xFF3184F2).value));
//   }

//   Future<void> _getMockFloods() async {
//     await _useCase.getMockFloods(onSuccess: (data) async {
//       listFloodFeatures.value = data.features ?? [];
//       _drawMarkers();
//     });
//   }

//   Future<void> _drawMarkers() async {
//     for (int i = 0; i < listFloodFeatures.length; i++) {
//       final feature = listFloodFeatures[i];
//       final lng = feature.geometry?.coordinates?[0];
//       final lat = feature.geometry?.coordinates?[1];

//       if (lng != null && lat != null) {
//         final options = CircleAnnotationOptions(
//           circleColor: Colors.red.value,
//           circleRadius: 8.0,
//           geometry: Point(
//             coordinates: Position(lng, lat),
//           ),
//         );
//         final annotation = await circleAnnotationManager?.create(options);

//         if (annotation != null) {
//           listFloodFeatures[i].markerId = annotation.id;
//         }
//       }
//     }
//     _attachListenerForAllMarkers();
//   }

//   void _attachListenerForAllMarkers() {
//     circleAnnotationManager?.addOnCircleAnnotationClickListener(
//       AnnotationClickListener(),
//     );
//   }

//   void _flyToPos(Position position) {
//     mapboxMap?.flyTo(
//         CameraOptions(zoom: 7.0, center: Point(coordinates: position)),
//         MapAnimationOptions(duration: 2000, startDelay: 300));
//   }

//   Future<void> _clearAnnotations() async {
//     listFloodFeatures.clear();
//     await polylineAnnotationManager?.deleteAll();
//     await circleAnnotationManager?.deleteAll();
//     polylineOptions.clear();
//   }
// }

// class AnnotationClickListener extends OnCircleAnnotationClickListener {
//   // Since mapbox doesn't support listener tapped for each marker(has only 1 circleAnnotationManager),
//   // we need to store marker's data into a list to handle tapped marker.
//   final tempListFeatures = Get.find<HomeController>().listFloodFeatures;
//   @override
//   void onCircleAnnotationClick(CircleAnnotation annotation) {
//     print(tempListFeatures
//             .firstWhere((element) => element.markerId == annotation.id)
//             .properties
//             ?.placeName ??
//         '');
//   }
// }
