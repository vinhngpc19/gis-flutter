import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:convert';

class AnnotationClickListener extends OnCircleAnnotationClickListener
    with BaseMixin {
  AnnotationClickListener({required this.context});
  // Since mapbox doesn't support listener tapped for each marker(1 circleAnnotationManager listens 1 marker),
  // we need to store marker's data into a list to handle tapped marker.
  final tempListFeatures = Get.find<HomeController>().listFloodFeatures;
  final BuildContext context;
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    _showModalBottomSheet(annotation);
  }

  void _showModalBottomSheet(CircleAnnotation annotation) {
    final item = tempListFeatures
        .firstWhere((element) => element.markerId == annotation.id)
        .properties;
    showModalBottomSheet(
        backgroundColor: color.backgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
            minChildSize: 0.2,
            initialChildSize: 0.2,
            maxChildSize: 0.6,
            expand: false,
            builder: (_, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Người khảo sát:',
                                style: textStyle.semiBold()),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(item?.surveyer ?? '',
                                  style: textStyle.regular()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Địa điểm:', style: textStyle.semiBold()),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(item?.placeName ?? '',
                                  style: textStyle.regular()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Ngày tạo:', style: textStyle.semiBold()),
                            const SizedBox(width: 4),
                            Text(item?.creationDa ?? '',
                                style: textStyle.regular()),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Ngày cập nhật:', style: textStyle.semiBold()),
                            const SizedBox(width: 4),
                            Text(item?.surveyDate ?? '',
                                style: textStyle.regular()),
                          ],
                        ),
                        if (item?.image != null) ...[
                          const SizedBox(height: 4),
                          Text('Ảnh:', style: textStyle.semiBold()),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(item!.image!),
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: 200,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )));
  }
}
