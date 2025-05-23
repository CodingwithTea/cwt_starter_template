import 'package:cwt_starter_template/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:cwt_starter_template/personalization/screens/profile/profile_screen.dart';
import 'package:cwt_starter_template/personalization/screens/profile/re_authenticate_phone_otp_screen.dart';
import 'package:cwt_starter_template/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/authentication/screens/phone_number/otp/phone_otp_screen.dart';
import '../features/authentication/screens/phone_number/phone_number_screen.dart';
import '../features/authentication/screens/welcome/welcome_screen.dart';
import '../features/dashboard/core/screens/dashboard/coursesDashboard.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: TRoutes.onboarding, page: () => const OnBoardingScreen()),
    GetPage(name: TRoutes.coursesDashboard, page: () => const CoursesDashboard()),

    GetPage(name: TRoutes.phoneSignIn, page: () => const PhoneNumberScreen()),
    GetPage(name: TRoutes.otpVerification, page: () => const PhoneOtpScreen()),
    GetPage(name: TRoutes.reAuthenticateOtpVerification, page: () => const ReAuthenticatePhoneOtpScreen()),
    GetPage(name: TRoutes.profileScreen, page: () => const ProfileScreen()),
  ];
}
