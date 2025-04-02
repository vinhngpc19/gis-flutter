import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/base/cache_manager.dart';
import 'package:gis_disaster_flutter/common/app_bar/home_app_bar.dart';
import 'package:gis_disaster_flutter/common/button/main_button.dart';
import 'package:gis_disaster_flutter/common/text_field/custom_input_text.dart';
import 'package:gis_disaster_flutter/common/text_field/date_picker.dart';
import 'package:gis_disaster_flutter/data/model/province.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';
import 'package:gis_disaster_flutter/r.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:image_picker/image_picker.dart' as picker;

class HomePage extends BaseScreen<HomeController> with CacheManager {
  HomePage({super.key});
  @override
  Widget builder() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: color.mainColor,
        foregroundColor: color.backgroundColor,
        onPressed: () async {
          if (controller.getUser() == null) {
            showCupertinoDialog(
              context: Get.context!,
              builder: (_) => CupertinoAlertDialog(
                title: Text('Thông báo', style: textStyle.semiBold(size: 16)),
                content: Text('Bạn cần đăng nhập để thêm điểm',
                    style: textStyle.regular()),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Quay lại',
                        style: textStyle.regular(color: color.redColor)),
                    onPressed: () => Get.back(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Tiếp tục',
                        style: textStyle.regular(color: color.mainColor)),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRouter.routerSignIn);
                    },
                  ),
                ],
              ),
            );
            return;
          }
          if (controller.localPos == null) {
            await controller
                .determinePosition()
                .whenComplete(controller.hideLoading);
            if (controller.localPos != null) {
              _showBottomSheet();
            }
          } else {
            _showBottomSheet();
          }
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: color.backgroundColor, size: 24),
      ),
      appBar: HomeAppBar(),
      backgroundColor: color.backgroundColor,
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          mb.MapWidget(
            onMapCreated: controller.onMapCreated,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer())
            },
            cameraOptions: mb.CameraOptions(
                zoom: 4.0,
                center: mb.Point(
                    coordinates: mb.Position(lngVietnamPos, latVietnamPos))),
          ),
          _buildFloatSelectedDisaster(),
        ],
      ),
    );
  }

  Widget _buildFloatSelectedDisaster() {
    return Obx(() => Visibility(
          visible: controller.isSelectedProvince.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
                children: List.generate(
                    controller.listDisasters.length,
                    (index) => _buildSelectedDisasterItem(
                        controller.listDisasters[index], index))),
          ),
        ));
  }

  Widget _buildSelectedDisasterItem(String title, int index) {
    return GestureDetector(
        onTap: () {
          if (controller.disasterSelectedAt.value != index) {
            controller.disasterSelectedAt.value = index;
            final Province province = controller.tabController.index == 1
                ? Province(
                    name1: controller.localProvinceName,
                    position: controller.listProvinces[1].position)
                : controller.listProvinces[controller.tabController.index];
            index == 0
                ? controller.getFloods(province: province)
                : controller.getErosions(province: province);
          }
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: controller.disasterSelectedAt.value == index
                    ? color.mainColor
                    : color.backgroundColor),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text(
                title,
                style: controller.disasterSelectedAt.value == index
                    ? textStyle.regular(size: 13, color: color.white)
                    : textStyle.regular(size: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: Get.context!,
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
                Row(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        AssetIcons.iconSwitchActive,
                        width: 20.0,
                      ),
                    ),
                    Text('Vị trí hiện tại của bạn', style: textStyle.semiBold())
                  ],
                ),
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
                Obx(() => Row(children: [
                      SizedBox(
                        width: 26,
                        child: CupertinoCheckbox(
                          activeColor: color.mainColor,
                          checkColor: CupertinoColors.white,
                          tristate: true,
                          shape: const CircleBorder(),
                          value: controller.isCheckedFlood.value ? true : false,
                          onChanged: (bool? value) {
                            if (!controller.isCheckedFlood.value) {
                              controller.isCheckedFlood.value = true;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text('Điểm lụt', style: textStyle.regular()),
                      const SizedBox(width: 50),
                      SizedBox(
                        width: 26,
                        child: CupertinoCheckbox(
                          activeColor: color.mainColor,
                          checkColor: CupertinoColors.white,
                          tristate: true,
                          shape: const CircleBorder(),
                          value: controller.isCheckedFlood.value ? false : true,
                          onChanged: (bool? value) {
                            if (controller.isCheckedFlood.value) {
                              controller.isCheckedFlood.value = false;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text('Điểm trượt lở', style: textStyle.regular()),
                    ])),
                Obx(() => GestureDetector(
                      onTap: () => _showImageSourceModal(),
                      child: Container(
                        width: double.infinity,
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
                                child: Image.file(
                                  controller.imageFile.value!,
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: Get.width,
                                ),
                              ),
                      ),
                    )),
                MainButton(
                  onPressed: controller.sendDisasterInfo,
                  padding: const EdgeInsets.only(top: 20),
                  title: 'Tạo',
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(controller.deleteTextWhenPopModal);
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: Get.context!,
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

  @override
  HomeController? putController() => HomeController();
}
