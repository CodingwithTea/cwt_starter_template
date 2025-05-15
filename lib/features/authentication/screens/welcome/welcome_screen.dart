import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/animations/fade_in_animation/animation_design.dart';
import '../../../../../utils/animations/fade_in_animation/fade_in_animation_controller.dart';
import '../../../../../utils/animations/fade_in_animation/fade_in_animation_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../email_authentication/login/login_screen.dart';
import '../email_authentication/signup/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.animationIn();

    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width;
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? TColors.secondary : TColors.primary,
        body: Stack(
          children: [
            TFadeInAnimation(
              isTwoWayAnimation: false,
              durationInMs: 1200,
              animate: TAnimatePosition(
                bottomAfter: 0,
                bottomBefore: -100,
                leftBefore: 0,
                leftAfter: 0,
                topAfter: 0,
                topBefore: 0,
                rightAfter: 0,
                rightBefore: 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(tag: 'welcome-image-tag', child: Image(image: const AssetImage(tWelcomeScreenImage), width: width * 0.7, height: height * 0.6)),
                    Column(
                      children: [
                        Text(tWelcomeTitle, style: Theme.of(context).textTheme.displayMedium),
                        Text(tWelcomeSubTitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => Get.to(() => const LoginScreen()), child: Text(tLogin.toUpperCase()))),
                        const SizedBox(width: 10.0),
                        Expanded(child: ElevatedButton(onPressed: () => Get.to(() => const SignupScreen()), child: Text(tSignup.toUpperCase()))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
