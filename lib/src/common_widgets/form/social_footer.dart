import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../constants/image_strings.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';
import '../../features/authentication/controllers/login_controller.dart';
import '../buttons/clickable_richtext_widget.dart';
import '../buttons/social_button.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({
    super.key,
    this.text1 = tDontHaveAnAccount,
    this.text2 = tSignup,
    required this.onPressed,
  });

  final String text1, text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      padding: const EdgeInsets.only(top: tDefaultSpace * 1.5, bottom: tDefaultSpace),
      child: Column(
        children: [
          Obx(
            () => TSocialButton(
              image: tGoogleLogo,
              background: tGoogleBgColor,
              foreground: tGoogleForegroundColor,
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              isLoading: controller.isGoogleLoading.value ? true : false,
              onPressed: controller.isFacebookLoading.value || controller.isLoading.value
                  ? () {}
                  : controller.isGoogleLoading.value
                      ? () {}
                      : () => controller.googleSignIn(),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => TSocialButton(
              image: tFacebookLogo,
              foreground: tWhiteColor,
              background: tFacebookBgColor,
              text: '${tConnectWith.tr} ${tFacebook.tr}',
              isLoading: controller.isFacebookLoading.value ? true : false,
              onPressed: controller.isGoogleLoading.value || controller.isLoading.value
                  ? () {}
                  : controller.isFacebookLoading.value
                  ? () {}
                  : () => controller.facebookSignIn(),
            ),
          ),
          const SizedBox(height: tDefaultSpace * 2),
          ClickableRichTextWidget(
            text1: text1.tr,
            text2: text2.tr,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
