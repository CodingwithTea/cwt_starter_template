import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/authentication/controllers/login_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../buttons/clickable_richtext_widget.dart';
import '../buttons/social_button.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key, this.text1 = tDontHaveAnAccount, this.text2 = tSignup, required this.onPressed});

  final String text1, text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      padding: const EdgeInsets.only(top: TSizes.defaultSpace * 1.5, bottom: TSizes.defaultSpace),
      child: Column(
        children: [
          Obx(
            () => TSocialButton(
              image: tGoogleLogo,
              background: TColors.googleBackgroundColor,
              foreground: TColors.googleForegroundColor,
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              isLoading: controller.isGoogleLoading.value ? true : false,
              onPressed:
                  controller.isFacebookLoading.value || controller.isLoading.value
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
              foreground: TColors.white,
              background: TColors.facebookBackgroundColor,
              text: '${tConnectWith.tr} ${tFacebook.tr}',
              isLoading: controller.isFacebookLoading.value ? true : false,
              onPressed:
                  controller.isGoogleLoading.value || controller.isLoading.value
                      ? () {}
                      : controller.isFacebookLoading.value
                      ? () {}
                      : () => controller.facebookSignIn(),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace * 2),
          ClickableRichTextWidget(text1: text1.tr, text2: text2.tr, onPressed: onPressed),
        ],
      ),
    );
  }
}
