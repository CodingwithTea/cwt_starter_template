import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/animations/fade_in_animation/animation_design.dart';
import '../../../../../utils/animations/fade_in_animation/fade_in_animation_controller.dart';
import '../../../../../utils/animations/fade_in_animation/fade_in_animation_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startSplashAnimation();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            TFadeInAnimation(
              durationInMs: 1200,
              animate: TAnimatePosition(topAfter: 0, topBefore: -30, leftBefore: -30, leftAfter: 0),
              child: const Image(image: AssetImage(TImages.tSplashTopIcon)),
            ),
            TFadeInAnimation(
              durationInMs: 1600,
              animate: TAnimatePosition(topBefore: 100, topAfter: 100, leftAfter: TSizes.defaultSpace, leftBefore: -100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TTexts.tAppName, style: Theme.of(context).textTheme.headlineSmall),
                  Text(TTexts.tAppTagLine, style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),
            TFadeInAnimation(
              durationInMs: 2000,
              animate: TAnimatePosition(bottomBefore: 0, bottomAfter: 100),
              child: const Image(image: AssetImage(TImages.tSplashImage)),
            ),
            TFadeInAnimation(
              durationInMs: 2000,
              animate: TAnimatePosition(bottomBefore: 0, bottomAfter: 60, rightBefore: TSizes.defaultSpace, rightAfter: TSizes.defaultSpace),
              child: Container(
                width: TSizes.xl,
                height: TSizes.xl,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: TColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
