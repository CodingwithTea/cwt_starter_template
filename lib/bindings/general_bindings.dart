import 'package:cwt_starter_template/features/cart/controllers/cart_controller.dart';
import 'package:cwt_starter_template/features/checkout/controllers/checkout_controller.dart';
import 'package:cwt_starter_template/features/products/controllers/product_controller.dart';
import 'package:cwt_starter_template/personalization/controllers/theme_controller.dart';
import 'package:get/get.dart';

import '../data/repository/authentication_repository/authentication_repository.dart';
import '../data/services/notifications/notification_service.dart';
import '../features/authentication/controllers/login_controller.dart';
import '../features/authentication/controllers/on_boarding_controller.dart';
import '../features/authentication/controllers/otp_controller.dart';
import '../features/authentication/controllers/signup_controller.dart';
import '../personalization/controllers/address_controller.dart';
import '../personalization/controllers/notification_controller.dart';
import '../personalization/controllers/user_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.put(NetworkManager());

    /// -- Repository
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.put(CartController());
    Get.put(ThemeController());
    Get.put(ProductController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => CheckoutController());
    Get.lazyPut(() => AddressController());

    Get.lazyPut(() => OnBoardingController(), fenix: true);

    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => OTPController(), fenix: true);
    Get.put(TNotificationService());
    Get.lazyPut(() => NotificationController(), fenix: true);
  }
}
