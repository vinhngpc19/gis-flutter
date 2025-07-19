import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/data/model/luquetsatlo_model.dart';
import 'package:gis_disaster_flutter/data/use_case/mock_disaster_use_case.dart';
import 'package:gis_disaster_flutter/global/app_enum.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/pages/forecast/component/forecast_annotation_click_listener.dart';

const double lngVietnamPos = 105.806692;
const double latVietnamPos = 15.903061;
const mapboxAccessToken =
    'pk.eyJ1Ijoia2hvbmdsdXVtYXRraGF1IiwiYSI6ImNtMmo2MHVwdTAyNnMybG9yNXhwb3hjY3cifQ.vua0uzDkJsMhbr7E0OsU-A';
const goongKey = '0cJVlGTB70CBs8p1QNvVIF3OCyX10ggIwVackjQJ';

class ForecastController extends BaseController {
  mb.MapboxMap? mapboxMap;
  mb.CircleAnnotationManager? circleAnnotationManager;
  final _useCase = MockDisasterUseCase();

  // Lấy giờ hiện tại khi khởi tạo controller
  final RxString selectedTime =
      ('${DateTime.now().hour.toString().padLeft(2, '0')}:00').obs;

  // Dữ liệu forecast
  final RxList<Temperatures> forecastData = <Temperatures>[].obs;
  final RxBool isLoadingForecast = false.obs;

  @override
  void onInit() {
    mb.MapboxOptions.setAccessToken(mapboxAccessToken);
    super.onInit();
    // Load dữ liệu forecast ban đầu
    _loadForecastData();
  }

  void onMapCreated(mb.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.logo.updateSettings(mb.LogoSettings(enabled: false));
    mapboxMap.attribution
        .updateSettings(mb.AttributionSettings(enabled: false));
    mapboxMap.scaleBar.updateSettings(mb.ScaleBarSettings(enabled: false));
    mapboxMap.loadStyleURI(
        'https://tiles.goong.io/assets/goong_light_v2.json?api_key=$goongKey');

    // Tạo circle annotation manager
    mapboxMap.annotations
        .createCircleAnnotationManager()
        .then((value) => circleAnnotationManager = value);
  }

  void onTimeChanged(String time) {
    selectedTime.value = time;
    _loadForecastData();
  }

  Future<void> _loadForecastData() async {
    isLoadingForecast.value = true;

    final now = DateTime.now();
    final timeParts = selectedTime.value.split(':');
    final hour = int.parse(timeParts[0]);
    final forecastDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
    );

    try {
      final data = await _useCase.getForecast(
        sogiodubao: 6,
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(forecastDateTime),
        onSuccess: () {},
        onError: () {},
      );
      forecastData.value = data;
      isLoadingForecast.value = false;
      _updateRadarData(selectedTime.value);
    } catch (e) {
      isLoadingForecast.value = false;
    }
  }

  void _updateRadarData(String time) {
    // Hiển thị dữ liệu forecast trên map
    _displayForecastOnMap();
  }

  Future<void> _displayForecastOnMap() async {
    // Xóa tất cả annotations cũ
    await circleAnnotationManager?.deleteAll();

    // Vẽ markers mới cho từng điểm dữ liệu
    for (int i = 0; i < forecastData.length; i++) {
      final temp = forecastData[i];
      if (temp.lat != null && temp.lon != null) {
        final options = _getCircleAnnotationOptions(temp);
        await circleAnnotationManager?.create(options);
      }
    }
    // Attach click listener cho marker
    circleAnnotationManager?.addOnCircleAnnotationClickListener(
        ForecastAnnotationClickListener(context: Get.context!));
  }

  mb.CircleAnnotationOptions _getCircleAnnotationOptions(Temperatures temp) {
    Color circleColor = Colors.grey;
    double circleRadius = 8.0;

    switch (temp.luQuetRisk) {
      case RiskLevel.thap:
        circleColor = Colors.green;
        circleRadius = 6.0;
        break;
      case RiskLevel.trungBinh:
        circleColor = Colors.yellow;
        circleRadius = 8.0;
        break;
      case RiskLevel.cao:
        circleColor = Colors.orange;
        circleRadius = 10.0;
        break;
      case RiskLevel.ratCao:
        circleColor = Colors.red;
        circleRadius = 12.0;
        break;
    }

    return mb.CircleAnnotationOptions(
      circleColor: circleColor.value,
      circleRadius: circleRadius,
      geometry: mb.Point(
        coordinates: mb.Position(temp.lon!, temp.lat!),
      ),
    );
  }

  Future<void> _clearAnnotations() async {
    forecastData.clear();
    await circleAnnotationManager?.deleteAll();
  }

  @override
  void onClose() {
    _clearAnnotations();
    mapboxMap?.dispose();
    super.onClose();
  }
}
