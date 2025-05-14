import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fade_in_animation_controller.dart';
import 'fade_in_animation_model.dart';

class TFadeInAnimation extends StatelessWidget {
  TFadeInAnimation({
    super.key,
    required this.durationInMs,
    required this.child,
    this.animate,
    this.isTwoWayAnimation = true,
  });

  final controller = Get.put(FadeInAnimationController());
  final int durationInMs;
  final TAnimatePosition? animate;
  final Widget child;
  final bool isTwoWayAnimation; //If two way then use animateTwoWay value otherwise animateSingle

  @override
  Widget build(BuildContext context) {
    return isTwoWayAnimation
        ? Obx(
            () => AnimatedPositioned(
              duration: Duration(milliseconds: durationInMs),
              top: controller.animateTwoWay.value ? animate!.topAfter : animate!.topBefore,
              left: controller.animateTwoWay.value ? animate!.leftAfter : animate!.leftBefore,
              bottom: controller.animateTwoWay.value ? animate!.bottomAfter : animate!.bottomBefore,
              right: controller.animateTwoWay.value ? animate!.rightAfter : animate!.rightBefore,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: durationInMs),
                opacity: controller.animateTwoWay.value ? 1 : 0,
                child: child,
              ),
            ),
          )
        : Obx(
            () => AnimatedPositioned(
              duration: Duration(milliseconds: durationInMs),
              top: controller.animateSingle.value ? animate!.topAfter : animate!.topBefore,
              left: controller.animateSingle.value ? animate!.leftAfter : animate!.leftBefore,
              bottom: controller.animateSingle.value ? animate!.bottomAfter : animate!.bottomBefore,
              right: controller.animateSingle.value ? animate!.rightAfter : animate!.rightBefore,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: durationInMs),
                opacity: controller.animateSingle.value ? 1 : 0,
                child: child,
              ),
            ),
          );
  }
}
