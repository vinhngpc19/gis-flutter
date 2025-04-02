import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:gis_disaster_flutter/base/cache_manager.dart';
import 'package:gis_disaster_flutter/base/import_base.dart';
import 'package:gis_disaster_flutter/common/helpers/snack_bar_helper.dart';
import 'package:gis_disaster_flutter/data/model/disaster_param.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/data/model/feature_polygon.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/data/use_case/mock_disaster_use_case.dart';
import 'package:gis_disaster_flutter/extensions/camera_extension.dart';
import 'package:gis_disaster_flutter/pages/home/component/annotation_click_listener.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

const double lngVietnamPos = 105.806692;
const double latVietnamPos = 15.903061;
const mapboxAccessToken = '';
const goongKey = '';

class HomeController extends BaseController
    with GetTickerProviderStateMixin, CacheManager {
  final _useCase = MockDisasterUseCase();

  MapboxMap? mapboxMap;
  PolylineAnnotationManager? polylineAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;

  final RxList<FeatureMarker> listFloodFeatures = <FeatureMarker>[].obs;
  final polylineOptions = <PolylineAnnotationOptions>[];
  RxInt disasterSelectedAt = 0.obs;
  List<String> listDisasters = ['Lũ lụt', 'Trượt lở'];
  RxBool isSelectedProvince = false.obs;
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  RxString initSurveyDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).obs;
  RxString updateSurveyDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now()).obs;

  final RxList<Province> listProvinces = <Province>[
    Province(name1: 'Bản đồ'),
    Province(name1: 'Hiện tại'),
  ].obs;

  late TabController tabController;
  Position? localPos;

  RxBool isCheckedFlood = true.obs;
  String? localProvinceName;
  Rx<File?> imageFile = Rx<File?>(null);

  @override
  void onInit() {
    MapboxOptions.setAccessToken(mapboxAccessToken);
    tabController = TabController(
        vsync: this, length: listProvinces.length, initialIndex: 0);
    super.onInit();
  }

  void _changeTabController() {
    tabController = TabController(
      vsync: this,
      length: listProvinces.length,
      initialIndex: listProvinces.length - 1,
    );
  }

  void onTapTabBar(int value) async {
    if (!tabController.indexIsChanging) return;
    if (value == 0) {
      tabController.animateTo(tabController.previousIndex,
          duration: Duration.zero);
      return;
    }
    if (value == 1) {
      if (localPos == null) {
        tabController.animateTo(tabController.previousIndex,
            duration: Duration.zero);
        await determinePosition().whenComplete(hideLoading);
      }
      if (localPos != null) {
        tabController.animateTo(1);
        await getLocalPolylineProvince();
      }
      return;
    }
    handleTabController(title: listProvinces[value]);
  }

  Future<void> getLocalPolylineProvince() async {
    await _useCase.getProvinceByPosition(
        latlng: '${localPos!.lat},${localPos!.lng}',
        onSuccess: (data) async {
          localProvinceName ??= data.compound?.province;
          await getPolylineAndMarker(
              province: Province(name1: data.compound?.province, position: [
            localPos!.lng.toDouble(),
            localPos!.lat.toDouble()
          ]));
        },
        onError: () {});
  }

  void handleTabController({required Province title}) {
    getPolylineAndMarker(province: title);
    if (!listProvinces.any((element) => element.name1 == title.name1)) {
      listProvinces.add(title);
      tabController.dispose();
      _changeTabController();
    }
  }

  Future<void> determinePosition() async {
    showLoading();
    geo.LocationPermission permission;
    final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location service s are disabled.');
    }
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final curPos = await geo.Geolocator.getCurrentPosition();
    localPos = Position(curPos.longitude, curPos.latitude);
    listProvinces[1].position = [
      localPos!.lng.toDouble(),
      localPos!.lat.toDouble()
    ];
  }

  void onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.loadStyleURI(
        'https://tiles.goong.io/assets/goong_light_v2.json?api_key=$goongKey');
    // reference my polylineAnnotationManager to 'value'
    mapboxMap.annotations
        .createPolylineAnnotationManager()
        .then((value) => polylineAnnotationManager = value);
    mapboxMap.annotations
        .createCircleAnnotationManager()
        .then((value) => circleAnnotationManager = value);
  }

  Future<void> getPolylineAndMarker({required Province province}) async {
    isSelectedProvince.value = false;
    disasterSelectedAt.value = 0;
    _useCase.getPolygon(
        provinces: province.name1 ?? '',
        onSuccess: (data) async {
          await _drawNewPolylines(data);
          isSelectedProvince.value = true;
          await getFloods(province: province);
        });
  }

  Future<void> _drawNewPolylines(FeaturePolygon polygon) async {
    _clearAnnotations();
    final coordinates = polygon.geometry?.coordinates;
    if (coordinates.length == 1) {
      _addPolylineOptions(coordinates);
    } else {
      for (final coordinate in coordinates) {
        _addPolylineOptions(coordinate);
      }
    }
    if (polylineOptions.isNotEmpty) {
      polylineOptions.length == 1
          ? await polylineAnnotationManager?.create(polylineOptions[0])
          : await polylineAnnotationManager?.createMulti(polylineOptions);
    }
  }

  void _addPolylineOptions(dynamic coordinates) {
    final tempList = coordinates[0];
    polylineOptions.add(PolylineAnnotationOptions(
        geometry: LineString(
            coordinates: List<Position>.generate((tempList as List).length,
                (index) => Position(tempList[index][0], tempList[index][1]))),
        lineWidth: 1.5,
        lineGapWidth: 0.0,
        lineColor: const Color(0xFF3184F2).value));
  }

  Future<void> getFloods({required Province province}) async {
    await circleAnnotationManager?.deleteAll();
    listFloodFeatures.clear();
    _flyToPos(Position(province.position![0], province.position![1]));
    showLoading();
    await _useCase
        .getFloods(
            province: province.name1 ?? '',
            onSuccess: (data) async {
              listFloodFeatures.value = data.features ?? [];
              if (listFloodFeatures.isNotEmpty) {
                await _drawMarkers();
              }
            })
        .whenComplete(hideLoading);
  }

  Future<void> getErosions({required Province province}) async {
    await circleAnnotationManager?.deleteAll();
    listFloodFeatures.clear();
    _flyToPos(Position(province.position![0], province.position![1]));
    showLoading();
    await _useCase
        .getErosions(
            province: province.name1 ?? '',
            onSuccess: (data) async {
              listFloodFeatures.value = data.features ?? [];
              if (listFloodFeatures.isNotEmpty) {
                await _drawMarkers();
              }
            })
        .whenComplete(hideLoading);
  }

  Future<void> _drawMarkers() async {
    for (int i = 0; i < listFloodFeatures.length; i++) {
      final feature = listFloodFeatures[i];
      final lng = feature.geometry?.coordinates?[0];
      final lat = feature.geometry?.coordinates?[1];

      if (lng != null && lat != null) {
        final options = disasterSelectedAt.value == 0
            ? feature.isUserSend == true
                ? CircleAnnotationOptions(
                    circleColor: Colors.yellow.value,
                    circleRadius: 8.0,
                    geometry: Point(
                      coordinates: Position(lng, lat),
                    ))
                : CircleAnnotationOptions(
                    circleColor: Colors.red.value,
                    circleRadius: 8.0,
                    geometry: Point(
                      coordinates: Position(lng, lat),
                    ),
                  )
            : feature.isUserSend == true
                ? CircleAnnotationOptions(
                    circleColor: Colors.yellow.value,
                    circleRadius: 8.0,
                    geometry: Point(
                      coordinates: Position(lng, lat),
                    ))
                : CircleAnnotationOptions(
                    circleColor: Colors.brown.value,
                    circleRadius: 8.0,
                    geometry: Point(
                      coordinates: Position(lng, lat),
                    ),
                  );
        final annotation = await circleAnnotationManager?.create(options);

        if (annotation != null) {
          listFloodFeatures[i].markerId = annotation.id;
        }
      }
    }
    _attachListenerForAllMarkers();
  }

  void _attachListenerForAllMarkers() {
    circleAnnotationManager?.addOnCircleAnnotationClickListener(
        AnnotationClickListener(context: Get.context!));
  }

  void _flyToPos(Position position) {
    mapboxMap?.flyTo(
        CameraOptions(zoom: 7.0, center: Point(coordinates: position)),
        MapAnimationOptions(duration: 2000, startDelay: 350));
  }

  Future<void> _clearAnnotations() async {
    isSelectedProvince.value = true;
    listFloodFeatures.clear();
    await polylineAnnotationManager?.deleteAll();
    await circleAnnotationManager?.deleteAll();
    polylineOptions.clear();
  }

  Future<String?> _getBase64Image() async {
    if (imageFile.value == null) return null;
    final bytes = await imageFile.value!.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> sendDisasterInfo() async {
    showLoading();
    if (localProvinceName == null) {
      await _useCase.getProvinceByPosition(
          latlng: '${localPos!.lat},${localPos!.lng}',
          onSuccess: (data) async {
            localProvinceName ??= data.compound?.province;
          },
          onError: () {
            hideLoading();
            Get.back();
            SnackBarHelper.showError('Gửi thất bại!');
            return;
          });
    }
    final base64Image = await _getBase64Image();
    await _useCase.sendMarker(
        param: DisasterParam(
            province: localProvinceName ?? '',
            isFlood: isCheckedFlood.value,
            placeName: locationController.text.isNotEmpty
                ? locationController.text
                : null,
            creationDa: initSurveyDate.value,
            surveyDate: updateSurveyDate.value,
            surveyer:
                nameController.text.isNotEmpty ? nameController.text : null,
            position: [localPos!.lng.toDouble(), localPos!.lat.toDouble()],
            image: base64Image),
        onSuccess: () async {
          hideLoading();
          Get.back();
          SnackBarHelper.showMessage('Gửi thành công!');
          deleteTextWhenPopModal();
          tabController.animateTo(1);
          getLocalPolylineProvince();
        },
        onError: () {
          hideLoading();
          Get.back();
          SnackBarHelper.showError('Gửi thất bại!');
        });
  }

  void deleteTextWhenPopModal() {
    final currentFormatDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    locationController.text = '';
    nameController.text = '';
    initSurveyDate.value = currentFormatDate;
    updateSurveyDate.value = currentFormatDate;
    imageFile.value = null;
    isCheckedFlood.value = true;
  }

  Future<void> pickImage({required picker.ImageSource imageSource}) async {
    final picker.XFile? imgFile = await CameraImageEx.handlePickImage(
      source: imageSource,
    );
    if (imgFile == null || imgFile.path.isEmpty) {
      return;
    } else {
      imageFile.value = File(imgFile.path);
    }
  }

  @override
  void onClose() {
    _clearAnnotations();
    mapboxMap?.dispose();
    tabController.dispose();
    super.onClose();
  }
}
