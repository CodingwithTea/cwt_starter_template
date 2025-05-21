import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';
import '../screens/welcome/welcome_screen.dart';

class OnBoardingController extends GetxController {
  //Variables
  final userStorage = GetStorage(); // Use for local Storage
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  //Functions to trigger Skip, Next and onPageChange Events
  skip() => controller.jumpToPage(page: 2);

  animateToNextSlide() => controller.animateToPage(page: controller.currentPage + 1);

  animateToNextSlideWithLocalStorage() {
    if (controller.currentPage == 2) {
      userStorage.write('isFirstTime', false);
      Get.offAll(() => const WelcomeScreen());
    } else {
      controller.animateToPage(page: controller.currentPage + 1);
    }
  }

  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;

  //Three Onboarding Pages
  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: TImages.tOnBoardingImage1,
        title: TTexts.tOnBoardingTitle1,
        subTitle: TTexts.tOnBoardingSubTitle1,
        counterText: TTexts.tOnBoardingCounter1,
        bgColor: TColors.onBoardingPage1Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: TImages.tOnBoardingImage2,
        title: TTexts.tOnBoardingTitle2,
        subTitle: TTexts.tOnBoardingSubTitle2,
        counterText: TTexts.tOnBoardingCounter2,
        bgColor: TColors.onBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: TImages.tOnBoardingImage3,
        title: TTexts.tOnBoardingTitle3,
        subTitle: TTexts.tOnBoardingSubTitle3,
        counterText: TTexts.tOnBoardingCounter3,
        bgColor: TColors.onBoardingPage3Color,
      ),
    ),
  ];
}
