import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/pages/dashboard/dashboard_controller.dart';
import 'package:gis_disaster_flutter/pages/home/home_page.dart';
import 'package:gis_disaster_flutter/pages/user/user_page.dart';
import 'package:gis_disaster_flutter/r.dart';

class DashboardPage extends BaseScreen<DashboardController> {
  DashboardPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentTabIndex.value,
            children: [
              HomePage(),
              UserPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (value) => controller.changePageIndex(index: value),
          currentIndex: controller.currentTabIndex.value,
          backgroundColor: color.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: color.mainColor,
          selectedLabelStyle:
              textStyle.regular(size: 12, color: color.mainColor),
          unselectedLabelStyle:
              textStyle.regular(size: 12, color: color.mainColor),
          items: <BottomNavigationBarItem>[
            _buildBottomNvBarItem(
                title: 'Trang chủ',
                index: 0,
                icon: AssetIcons.iconMap,
                activeIcon: AssetIcons.iconMapActive),
            _buildBottomNvBarItem(
                title: 'Cá nhân',
                index: 0,
                icon: AssetIcons.iconUser,
                activeIcon: AssetIcons.iconUserActive),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNvBarItem(
      {required String title,
      required int index,
      required String icon,
      required String activeIcon}) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(activeIcon),
      icon: SvgPicture.asset(icon),
      label: title,
    );
  }

  @override
  DashboardController? putController() => DashboardController();
}
