import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';
import 'package:gis_disaster_flutter/data/model/luquetsatlo_model.dart';
import 'package:gis_disaster_flutter/pages/forecast/forecast_controller.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:gis_disaster_flutter/utils/utils.dart';

class ForecastAnnotationClickListener extends OnCircleAnnotationClickListener
    with BaseMixin {
  ForecastAnnotationClickListener({required this.context});

  final tempListFeatures = Get.find<ForecastController>().forecastData;
  final BuildContext context;

  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    _showModalBottomSheet(annotation);
  }

  void _showModalBottomSheet(CircleAnnotation annotation) {
    // Tìm dữ liệu forecast tương ứng với annotation (dựa vào lat/lon)
    final Temperatures? forecastItem =
        _findForecastItemByAnnotation(annotation);
    if (forecastItem == null) return;

    showModalBottomSheet(
      backgroundColor: color.backgroundColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        minChildSize: 0.3,
        initialChildSize: 0.5,
        maxChildSize: 0.7,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với tên xã/phường
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: color.mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: color.mainColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      forecastItem.communeName ?? 'Không xác định',
                      style:
                          textStyle.semiBold(size: 18, color: color.mainColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Thông tin cơ bản
                _buildInfoSection(
                  'Thông tin địa lý',
                  [
                    _buildInfoRow('Tỉnh/Thành phố:',
                        forecastItem.provinceName ?? 'Không xác định'),
                    _buildInfoRow('Quận/Huyện:',
                        forecastItem.districtName ?? 'Không xác định'),
                    _buildInfoRow('Xã/Phường:',
                        forecastItem.communeName ?? 'Không xác định'),
                    _buildInfoRow('Thời gian:',
                        parseDateFromDotNetString(forecastItem.thoigian)),
                  ],
                ),

                const SizedBox(height: 16),

                // Thông tin dự báo
                _buildInfoSection(
                  'Thông tin dự báo',
                  [
                    _buildRainInfoRow(
                        'Lượng mưa thực đo:', forecastItem.luongmuatd),
                    _buildRainInfoRow(
                        'Lượng mưa dự báo:', forecastItem.luongmuadb),
                    _buildInfoRow(
                        'Số giờ dự báo:',
                        forecastItem.sogiodubao?.toString() ??
                            'Không xác định'),
                  ],
                ),

                const SizedBox(height: 16),

                // Thông tin nguy cơ
                _buildRiskSection(
                  'Đánh giá nguy cơ',
                  [
                    _buildRiskInfo('Nguy cơ sạt lở:', forecastItem.nguycosatlo),
                    _buildRiskInfo(
                        'Nguy cơ lũ quét:', forecastItem.nguycoluquet),
                  ],
                ),

                // Thông tin cập nhật
                if (forecastItem.nguoiCapnhat != null ||
                    forecastItem.ngayCapnhat != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'Thông tin cập nhật',
                    [
                      if (forecastItem.nguoiCapnhat != null)
                        _buildInfoRow(
                            'Người cập nhật:', forecastItem.nguoiCapnhat!),
                      if (forecastItem.ngayCapnhat != null)
                        _buildInfoRow(
                            'Ngày cập nhật:',
                            parseDateFromDotNetString(
                                forecastItem.ngayCapnhat)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle.semiBold(size: 16, color: color.mainColor),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRiskSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50]!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle.semiBold(size: 16, color: Colors.red[700]!),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: textStyle.semiBold(size: 14, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textStyle.regular(size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRainInfoRow(String label, double? rainValue) {
    Color rainColor = Colors.grey;
    String displayValue = rainValue != null
        ? '${rainValue.toStringAsFixed(1)} mm'
        : 'Không có dữ liệu';
    // Xác định màu sắc dựa trên lượng mưa (mm/h)
    if (rainValue != null) {
      if (rainValue < 1) {
        rainColor = const Color(0xFF87CEEB); // Light blue
      } else if (rainValue < 5) {
        rainColor = const Color(0xFF4682B4); // Steel blue
      } else if (rainValue < 10) {
        rainColor = const Color(0xFF0000FF); // Blue
      } else if (rainValue < 20) {
        rainColor = const Color(0xFFFFFF00); // Yellow
      } else if (rainValue < 30) {
        rainColor = const Color(0xFFFFA500); // Orange
      } else if (rainValue < 50) {
        rainColor = const Color(0xFFFF0000); // Red
      } else {
        rainColor = const Color(0xFF8B008B); // Purple
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: textStyle.semiBold(size: 14, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Text(
                  displayValue,
                  style: textStyle.regular(size: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: rainColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskInfo(String label, String? riskValue) {
    Color riskColor = Colors.grey;
    String displayValue = riskValue ?? 'Không xác định';

    if (riskValue != null) {
      switch (riskValue.toLowerCase()) {
        case 'thấp':
          riskColor = Colors.green;
          break;
        case 'trung bình':
          riskColor = Colors.yellow[700]!;
          break;
        case 'cao':
          riskColor = Colors.orange;
          break;
        case 'rất cao':
          riskColor = Colors.red;
          break;
        default:
          riskColor = Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: textStyle.semiBold(size: 14, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: riskColor.withOpacity(0.5)),
            ),
            child: Text(
              displayValue,
              style: textStyle.semiBold(size: 14, color: riskColor),
            ),
          ),
        ],
      ),
    );
  }

  Temperatures? _findForecastItemByAnnotation(CircleAnnotation annotation) {
    // Dựa vào vị trí lat/lon của annotation để tìm forecast item tương ứng
    final geometry = annotation.geometry;
    if (geometry is Point) {
      final pos = geometry.coordinates;
      for (final item in tempListFeatures) {
        if (item.lat != null && item.lon != null) {
          // So sánh với sai số nhỏ
          if ((item.lat! - pos.lat).abs() < 0.0001 &&
              (item.lon! - pos.lng).abs() < 0.0001) {
            return item;
          }
        }
      }
    }
    return null;
  }
}
