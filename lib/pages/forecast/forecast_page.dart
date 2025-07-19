import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/pages/forecast/forecast_controller.dart';
import 'package:gis_disaster_flutter/pages/forecast/component/rain_radar_map.dart';
import 'package:gis_disaster_flutter/pages/forecast/component/rain_intensity_legend.dart';
import 'package:timeline_slider/timeline_slider.dart';
import 'package:gis_disaster_flutter/global/app_enum.dart';

const double lngVietnamPos = 105.806692;
const double latVietnamPos = 15.903061;

class ForecastPage extends BaseScreen<ForecastController> {
  ForecastPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      appBar: AppBar(
        backgroundColor: color.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Rain Radar',
          style: textStyle.semiBold(size: 18),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RainIntensityLegend(),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  RainRadarMap(
                    onMapCreated: controller.onMapCreated,
                    cameraOptions: mb.CameraOptions(
                      zoom: 4.0,
                      center: mb.Point(
                        coordinates: mb.Position(lngVietnamPos, latVietnamPos),
                      ),
                    ),
                  ),
                  Obx(() => controller.isLoadingForecast.value
                      ? Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink()),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Obx(() => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thời gian: ${controller.selectedTime.value}',
                                style: textStyle.regular(size: 12),
                              ),
                              Text(
                                'Điểm dữ liệu: ${controller.forecastData.length}',
                                style: textStyle.regular(size: 12),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mức độ nguy hiểm:',
                            style: textStyle.semiBold(size: 12),
                          ),
                          const SizedBox(height: 4),
                          _buildLegendItem('Thấp', Colors.green, 6.0),
                          _buildLegendItem('Trung bình', Colors.yellow, 8.0),
                          _buildLegendItem('Cao', Colors.orange, 10.0),
                          _buildLegendItem('Rất cao', Colors.red, 12.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TimelineSlider(
              selectedTime: controller.selectedTime.string,
              timePoints: TimePoint.allTimePoints,
              onTimeChanged: controller.onTimeChanged,
              showTitle: true,
              title: "Time",
              showIconButton: true,
              onIconPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: textStyle.regular(size: 10),
          ),
        ],
      ),
    );
  }

  @override
  ForecastController? putController() => ForecastController();
}
