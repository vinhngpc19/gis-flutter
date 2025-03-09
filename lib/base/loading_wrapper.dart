import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/common/loading/circle_loading.dart';
import 'base_screen.dart';

class LoadingWrapper extends BaseScreen<LoadingController> {
  LoadingWrapper({super.key, this.child});

  final Widget? child;
  @override
  Widget builder() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          child ?? const SizedBox(),
          Obx(
            () => Visibility(
              visible: controller.loadingCtrl.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: const Color(0xFF131615).withOpacity(0.2),
                    ),
                  ),
                  _buildLoading()
                ],
              ),
            ),
          )
        ]));
  }

  Widget _buildLoading() {
    return const CircleLoading();
  }

  @override
  LoadingController? putController() => LoadingController();
}

class LoadingController extends BaseController {
  RxBool loadingCtrl = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void show() {
    loadingCtrl.value = true;
  }

  void hide() {
    loadingCtrl.value = false;
  }

  void hideAll() {
    loadingCtrl.value = false;
  }
}
