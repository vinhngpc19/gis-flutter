import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/base_widget.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/pages/home/home_controller.dart';

class HomeAppBar extends BaseWidget<HomeController>
    implements PreferredSizeWidget {
  HomeAppBar({super.key});

  @override
  Widget builder() {
    return AppBar(
        backgroundColor: color.backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: null,
        elevation: 0,
        flexibleSpace: Obx(() => Padding(
              padding: const EdgeInsets.only(right: 50),
              child: TabBar(
                dividerHeight: 0.0,
                isScrollable: true,
                onTap: controller.onTapTabBar,
                controller: controller.tabController,
                labelStyle: textStyle.regular(color: color.mainColor, size: 16),
                indicatorColor: color.mainColor,
                unselectedLabelStyle:
                    textStyle.regular(color: color.greyTextColor, size: 16),
                tabs: controller.listProvinces
                    .map((element) => Tab(text: element.name1))
                    .toList(),
              ),
            )),
        actions: [
          Container(
            height: 36,
            width: 50,
            decoration: BoxDecoration(
                color: color.mainColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.only(right: 9.0),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.toNamed(AppRouter.routerLocations),
                  child: Icon(Icons.add, size: 19, color: color.white)),
            ),
          )
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
