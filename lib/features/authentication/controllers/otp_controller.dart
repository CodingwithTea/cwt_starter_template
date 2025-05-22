import 'dart:async';

import 'package:get/get.dart';

import '../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  /// Variables
  String otp = '';
  String channel = '';
  final RxBool loader = false.obs;
  bool pinScreen = false;
  Rx<String> phoneNumberWithCountryCode = ''.obs;
  Rx<String> phoneNumber = ''.obs;

  /// Timer
  var secondsRemaining = 60.obs;
  var isButtonEnabled = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void init() {
    phoneNumberWithCountryCode.value = Get.parameters['phoneNumberWithCountryCode'] ?? '';
    phoneNumber.value = Get.parameters['phoneNumber'] ?? '';
    pinScreen = Get.parameters['pinScreen'] == 'true' ? true : false;
  }

  void startTimer() {
    try {
      if (_timer != null) {
        _timer?.cancel();
      }

      secondsRemaining.value = 60;
      isButtonEnabled.value = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          isButtonEnabled.value = true;
          _timer!.cancel();
        }
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    }
  }

  Future<void> resendOTP() async {
    try {
      // Trigger the OTP resend logic
      await AuthenticationRepository.instance.loginWithPhoneNo(phoneNumberWithCountryCode.value);

      // Show success message if OTP is verified
      TLoaders.successSnackBar(title: TTexts.otpSendTitle.tr, message: TTexts.otpSendMessage.tr);

      startTimer(); // Restart the timer
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.unableToSendOTP.tr, message: e.toString());
    }
  }

  /// -- SIGNUP
  Future<void> verifyOTP() async {
    try {
      if (otp.isEmpty) return;

      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Verify OTP
      var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
      AuthenticationRepository.instance.phoneNoVerificationId.value = "";
      TFullScreenLoader.stopLoading();

      // Return result to the previous screen
      Get.back(result: isVerified);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: TTexts.ohSnap, message: e.toString());
    }
  }
}
