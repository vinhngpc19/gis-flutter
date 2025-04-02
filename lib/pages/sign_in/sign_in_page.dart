import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_disaster_flutter/base/base_screen.dart';
import 'package:gis_disaster_flutter/common/button/main_button.dart';
import 'package:gis_disaster_flutter/r.dart';
import 'sign_in_controller.dart';

class SignInPage extends BaseScreen<SignInController> {
  SignInPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffE2F2FF), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              const FlutterLogo(size: 140),
              const SizedBox(height: 30),
              Text('Đăng nhập', style: textStyle.semiBold(size: 26)),
              const SizedBox(height: 4),
              Text(
                  'Chào mừng bạn đến với ứng dụng VDisaster!\nVui lòng đăng nhập để sử dụng ứng dụng',
                  textAlign: TextAlign.center,
                  style: textStyle.regular(size: 14)),
              MainButton(
                  padding: const EdgeInsets.only(top: 35),
                  onPressed: controller.signInWithGoogle,
                  title: 'Đăng nhập bằng Google',
                  bgColor: color.backgroundColor,
                  textSize: 14,
                  borderColor: Colors.grey,
                  textColor: color.black,
                  prefixIcon: AssetIcons.iconGoogle),
              const SizedBox(height: 10),
              Text('hoặc',
                  style:
                      textStyle.regular(size: 14, color: color.greyTextColor)),
              MainButton(
                onPressed: () {},
                padding: const EdgeInsets.only(top: 10),
                title: 'Đăng nhập bằng mật khẩu',
                bgColor: color.mainColor,
                textSize: 14,
                textColor: color.backgroundColor,
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  SvgPicture.asset(AssetIcons.iconSwitchActive, height: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: textStyle.regular(),
                        children: <TextSpan>[
                          const TextSpan(text: 'Tôi đồng ý và chấp nhận '),
                          TextSpan(
                              text: 'Chính sách và quyền riêng tư',
                              style: textStyle.regular(
                                color: const Color(0xff0284F2),
                                decoration: TextDecoration.underline,
                              )),
                          const TextSpan(
                              text: ' khi sử dụng ứng dụng VDisaster'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SignInController putController() => SignInController();
}
