import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';
import 'package:gis_disaster_flutter/common/button/main_button.dart';
import 'package:gis_disaster_flutter/common/text_field/custom_input_text.dart';
import 'package:gis_disaster_flutter/common/text_field/date_picker.dart';
import 'package:gis_disaster_flutter/data/model/feature_marker.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:convert';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart' as picker;

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
    final FeatureMarker item = tempListFeatures
        .firstWhere((element) => element.markerId == annotation.id);
    final itemProperties = item.properties;
    showModalBottomSheet(
        backgroundColor: color.backgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
            minChildSize: (itemProperties?.image ?? '').isNotEmpty ? 0.6 : 0.3,
            initialChildSize:
                (itemProperties?.image ?? '').isNotEmpty ? 0.6 : 0.3,
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
                        Column(
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
                                  child: Text(itemProperties?.surveyer ?? '',
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
                                  child: Text(itemProperties?.placeName ?? '',
                                      style: textStyle.regular()),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Ngày tạo:', style: textStyle.semiBold()),
                                const SizedBox(width: 4),
                                Text(itemProperties?.creationDa ?? '',
                                    style: textStyle.regular()),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Ngày cập nhật:',
                                    style: textStyle.semiBold()),
                                const SizedBox(width: 4),
                                Text(itemProperties?.surveyDate ?? '',
                                    style: textStyle.regular()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Độ ngập nhà:',
                                    style: textStyle.semiBold()),
                                const SizedBox(width: 4),
                                Text(
                                    itemProperties?.floodHouse.toString() ?? '',
                                    style: textStyle.regular()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Độ ngập đường:',
                                    style: textStyle.semiBold()),
                                const SizedBox(width: 4),
                                Text(itemProperties?.floodRoad.toString() ?? '',
                                    style: textStyle.regular()),
                              ],
                            ),
                            if (itemProperties?.image != null) ...[
                              const SizedBox(height: 4),
                              Text('Ảnh:', style: textStyle.semiBold()),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(itemProperties!.image!),
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: 200,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (item.isUserSend == true)
                          MainButton(
                            onPressed: () {
                              Get.back();
                              _showUpdateBottomSheet(annotation);
                            },
                            title: 'Cập nhật',
                            padding: const EdgeInsets.only(top: 30),
                          )
                      ],
                    ),
                  ),
                )));
  }

  void _showUpdateBottomSheet(CircleAnnotation annotation) {
    final controller = Get.find<HomeController>();
    final FeatureMarker item = tempListFeatures
        .firstWhere((element) => element.markerId == annotation.id);
    final itemProperties = item.properties;

    controller.locationController.text = itemProperties?.placeName ?? '';
    controller.nameController.text = itemProperties?.surveyer ?? '';
    controller.initSurveyDate.value =
        (itemProperties?.creationDa ?? '').contains('-')
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(itemProperties?.creationDa ?? ''))
            : (itemProperties?.creationDa ?? '');
    controller.updateSurveyDate.value =
        (itemProperties?.surveyDate ?? '').contains('-')
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(itemProperties?.surveyDate ?? ''))
            : (itemProperties?.surveyDate ?? '');
    controller.isCheckedFlood.value = (itemProperties?.floodHouse != null ||
        itemProperties?.floodRoad != null);
    if (itemProperties?.image != null) {
      controller.imageFile.value =
          File.fromRawPath(base64Decode(itemProperties!.image!));
    }

    showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      backgroundColor: color.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputText(
                    title: 'Địa điểm',
                    hintText: 'Nhập địa điểm',
                    controller: controller.locationController,
                    marginTop: 12),
                CustomInputText(
                    title: 'Nhập tên người tạo',
                    hintText: 'Nhập tên người tạo',
                    controller: controller.nameController,
                    marginTop: 12),
                Obx(() => DatePicker(
                      marginTop: 12,
                      initDate: controller.initSurveyDate.value,
                      title: 'Ngày khảo sát',
                      onChange: (date) {
                        controller.initSurveyDate.value = date;
                      },
                    )),
                Obx(() => DatePicker(
                      marginTop: 12,
                      initDate: controller.updateSurveyDate.value,
                      title: 'Ngày cập nhật',
                      onChange: (date) {
                        controller.updateSurveyDate.value = date;
                      },
                    )),
                const SizedBox(height: 16),
                Obx(() => GestureDetector(
                      onTap: () => _showImageSourceModal(),
                      child: Container(
                        width: Get.width,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: controller.imageFile.value == null
                            ? const Center(
                                child: Icon(Icons.add,
                                    size: 40, color: Colors.grey),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(itemProperties!.image!),
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: 200,
                                ),
                              ),
                      ),
                    )),
                if (item.isUserSend == true)
                  MainButton(
                    onPressed: () {
                      controller.updateDisasterInfo(item.id ?? '');
                    },
                    padding: const EdgeInsets.only(top: 20),
                    title: 'Cập nhật',
                  ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(
      () async {
        await Future.delayed(const Duration(milliseconds: 350));
        controller.deleteTextWhenPopModal();
      },
    );
  }

  void _showImageSourceModal() {
    final controller = Get.find<HomeController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: color.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Chọn ảnh', style: textStyle.regular()),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(imageSource: picker.ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Chụp ảnh', style: textStyle.regular()),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(imageSource: picker.ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
