import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/authentication/controllers/login_controller.dart';
import '../../../features/authentication/screens/phone_number/phone_number_screen.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../buttons/clickable_richtext_widget.dart';
import '../buttons/primary_button.dart';
import '../buttons/social_button.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key, this.text1 = TTexts.tDontHaveAnAccount, this.text2 = TTexts.tSignup, required this.onPressed});

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
            () => TPrimaryButton(
              isLoading: controller.isLoading.value ? true : false,
              text: '${TTexts.tConnectWith.tr} ${TTexts.tPhoneNumber.tr}',
              onPressed:
                  controller.isGoogleLoading.value || controller.isLoading.value
                      ? () {}
                      : controller.isFacebookLoading.value
                      ? () {}
                      // : () => controller.facebookSignIn(),
                      : () => Get.to(() => const PhoneNumberScreen()),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => TSocialButton(
              image: TImages.tGoogleLogo,
              background: TColors.googleBackgroundColor,
              foreground: TColors.googleForegroundColor,
              text: '${TTexts.tConnectWith.tr} ${TTexts.tGoogle.tr}',
              isLoading: controller.isGoogleLoading.value ? true : false,
              onPressed:
                  controller.isFacebookLoading.value || controller.isLoading.value
                      ? () {}
                      : controller.isGoogleLoading.value
                      ? () {}
                      : () => controller.googleSignIn(),
            ),
          ),
          // const SizedBox(height: 10),
          // Obx(
          //   () => TSocialButton(
          //     image: TImages.tFacebookLogo,
          //     foreground: TColors.white,
          //     background: TColors.iconPrimaryLight,
          //     text: '${TTexts.tConnectWith.tr} ${TTexts.tPhoneNumber.tr}',
          //     isLoading: controller.isFacebookLoading.value ? true : false,
          //     onPressed:
          //         controller.isGoogleLoading.value || controller.isLoading.value
          //             ? () {}
          //             : controller.isFacebookLoading.value
          //             ? () {}
          //             // : () => controller.facebookSignIn(),
          //             : () => Get.to(() => const PhoneNumberScreen()),
          //   ),
          // ),
          const SizedBox(height: TSizes.defaultSpace * 2),
          ClickableRichTextWidget(text1: text1.tr, text2: text2.tr, onPressed: onPressed),
        ],
      ),
    );
  }
}
