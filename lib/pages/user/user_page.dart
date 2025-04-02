import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/common/button/main_button.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/pages/user/component/setting_page_screen_item.dart';
import 'package:gis_disaster_flutter/pages/user/component/setting_page_view_item.dart';
import 'package:gis_disaster_flutter/pages/user/user_controller.dart';

class UserPage extends BaseScreen<UserController> {
  UserPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(
            () => !controller.isLoggedIn.value
                ? _buildViewFromList(controller.listFeatureNotLoggedIn)
                : _buildViewFromList(controller.listFeatureLoggedIn),
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: color.backgroundColor,
    );
  }

  Widget _buildViewFromList(List<SettingPageScreenItem> items) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            return SettingPageViewItem(
              onTap: () {
                if (item.feature == 'Đăng ký' || item.feature == 'Đăng nhập') {
                  Get.toNamed(AppRouter.routerSignIn);
                }
              },
              icon: item.icon,
              label: item.feature,
              value: '',
              line: item != items.last,
            );
          }).toList(),
        ),
        const SizedBox(height: 50),
        controller.isLoggedIn.value == true
            ? MainButton(
                onPressed: controller.handleSignOut,
                title: 'Đăng xuất',
                bgColor: color.mainColor,
              )
            : const SizedBox()
      ],
    );
  }

  @override
  UserController? putController() => UserController();
}
