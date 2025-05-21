import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  /// Variables
  final localStorage = GetStorage();
  final phone = TextEditingController();
  final selectedCountryCode = RxString('+225'); // Controller for selected country code

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    phone.text = localStorage.read('REMEMBER_ME_PHONE') ?? '';
    super.onInit();
  }

  /// Method to handle login with phone number
  Future<void> loginWithPhoneNumber() async {
    try {
      // Ensure country code is selected
      if (selectedCountryCode.value.isEmpty) {
        TLoaders.customToast(message: TTexts.selectCountryCode);
        return;
      }

      // Validate form inputs
      if (!signInFormKey.currentState!.validate()) return;

      // Show loading dialog
      TFullScreenLoader.openLoadingDialog(TTexts.sendingOTP, TImages.docerAnimation);

      // Check internet connectivity
      if (!await _checkInternetConnectivity()) return;

      // Format phone number with country code
      String formattedPhoneNumber = TFormatter.formatPhoneNumberWithCountryCode(
        selectedCountryCode.value,
        phone.text.trim(),
      );

      // Send OTP to phone number
      await AuthenticationRepository.instance.loginWithPhoneNo(formattedPhoneNumber);

      // Redirect to OTP screen for verification
      bool otpVerified = await Get.toNamed(TRoutes.otpVerification, parameters: {'phoneNumberWithCountryCode': formattedPhoneNumber, 'phoneNumber': phone.text.trim()});

      if (otpVerified) {
        // Show success message if OTP is verified
        TLoaders.successSnackBar(title: TTexts.phoneVerifiedTitle, message: TTexts.phoneVerifiedMessage);

        // Redirect to the appropriate screen
        await AuthenticationRepository.instance.screenRedirect(FirebaseAuth.instance.currentUser);
      } else {
        // Stop loading dialog
        TFullScreenLoader.stopLoading();
        return;
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('OTP VERIFIED: $e');
      _handleException(e);
    }
  }

  /// Helper method to check internet connectivity
  Future<bool> _checkInternetConnectivity() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: TTexts.noInternet.tr, message: TTexts.checkInternetConnection.tr);
      return false;
    }
    return true;
  }

  /// Helper method to handle exceptions
  void _handleException(Object e) {
    // Stop loading dialog and show error message
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: TTexts.ohSnap, message: e.toString());
  }
}
