import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gis_disaster_flutter/base/base_controller.dart';
import 'package:gis_disaster_flutter/base/cache_manager.dart';
import 'package:gis_disaster_flutter/global/app_router.dart';
import 'package:gis_disaster_flutter/pages/user/component/setting_page_screen_item.dart';
import 'package:gis_disaster_flutter/r.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends BaseController with CacheManager {
  RxList<SettingPageScreenItem> listFeatureNotLoggedIn =
      <SettingPageScreenItem>[
    SettingPageScreenItem(
        'Đăng nhập', AssetIcons.iconLogin, SettingPageScreenItem.feature_login),
    SettingPageScreenItem('Đăng ký', AssetIcons.iconRegister,
        SettingPageScreenItem.feature_register),
    SettingPageScreenItem('Ngôn ngữ', AssetIcons.iconLanguage,
        SettingPageScreenItem.feature_app_language),
    SettingPageScreenItem('Hướng dẫn sử dụng', AssetIcons.iconUserGuide,
        SettingPageScreenItem.feature_userGuide),
    SettingPageScreenItem('Đánh giá ứng dụng', AssetIcons.iconRateApp,
        SettingPageScreenItem.feature_rate_app),
    SettingPageScreenItem('Thông tin ứng dụng', AssetIcons.iconInformation,
        SettingPageScreenItem.feature_app_info)
  ].obs;
  RxList<SettingPageScreenItem> listFeatureLoggedIn = <SettingPageScreenItem>[
    SettingPageScreenItem(
        'Thông tin người dùng',
        AssetIcons.iconUserInformation,
        SettingPageScreenItem.feature_user_info),
    SettingPageScreenItem('Phản hồi và hỗ trợ', AssetIcons.iconFeedback,
        SettingPageScreenItem.feature_feedback_support),
    SettingPageScreenItem('Ngôn ngữ ứng dụng', AssetIcons.iconLanguage,
        SettingPageScreenItem.feature_app_language),
    SettingPageScreenItem('Hướng dẫn sử dụng', AssetIcons.iconUserGuide,
        SettingPageScreenItem.feature_userGuide),
    SettingPageScreenItem('Đánh giá app', AssetIcons.iconRateApp,
        SettingPageScreenItem.feature_rate_app),
    SettingPageScreenItem('Thông tin ứng dụng', AssetIcons.iconInformation,
        SettingPageScreenItem.feature_app_info)
  ].obs;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    if (getUser() != null) {
      isLoggedIn.value = true;
    }
    super.onInit();
  }

  void handleSignIn() {
    Get.toNamed(AppRouter.routerSignIn);
  }

  Future<void> handleSignOut() async {
    showLoading();
    await deleteUser();
    await GoogleSignIn().signOut();
    isLoggedIn.value = false;
    Future.delayed(const Duration(seconds: 1)).whenComplete(hideLoading);
  }
}
