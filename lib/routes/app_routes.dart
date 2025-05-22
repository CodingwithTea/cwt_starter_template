import 'package:cwt_starter_template/personalization/screens/profile/re_authenticate_phone_otp_screen.dart';
import 'package:cwt_starter_template/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/authentication/screens/phone_number/otp/phone_otp_screen.dart';
import '../features/authentication/screens/phone_number/phone_number_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.phoneSignIn, page: () => const PhoneNumberScreen()),
    GetPage(name: TRoutes.otpVerification, page: () => const PhoneOtpScreen()),
    GetPage(name: TRoutes.reAuthenticateOtpVerification, page: () => const ReAuthenticatePhoneOtpScreen()),
    // GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    // GetPage(name: TRoutes.homeMenu, page: () => const HomeMenu()),
    // GetPage(name: TRoutes.homeMenu, page: () => const HomeMenu()),
  ];
}
