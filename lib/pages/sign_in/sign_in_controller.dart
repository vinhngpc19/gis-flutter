import 'package:get/get.dart';
import 'package:gis_disaster_flutter/base/cache_manager.dart';
import 'package:gis_disaster_flutter/base/import_base.dart';
import 'package:gis_disaster_flutter/data/model/user.dart';
import 'package:gis_disaster_flutter/pages/user/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInController extends BaseController with CacheManager {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      showLoading();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // save user here
        await saveUser(User(
          id: googleUser.id,
          name: googleUser.displayName ?? '',
          email: googleUser.email,
          photoUrl: googleUser.photoUrl,
        ));
        Get.find<UserController>().isLoggedIn.value = true;

        Get.back();
      }
    } catch (error) {
      Get.snackbar(
        'Lỗi',
        'Đăng nhập thất bại: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      hideLoading();
    }
  }
}
