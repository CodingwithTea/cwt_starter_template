import 'package:cwt_starter_template/personalization/controllers/create_notification_controller.dart';
import 'package:cwt_starter_template/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../data/services/notifications/notification_service.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// Loader
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// [EmailAndPasswordLogin]
  Future<void> emailAndPasswordLogin() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.customToast(message: 'No Internet Connection');
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Login user using EMail & Password Authentication
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      final token = await TNotificationService.getToken();
      final userController = Get.put(UserController());
      await  userController.updateUserRecordWithToken(token);
      // Assign user data to RxUser of UserController to use in app
      await userController.fetchUserRecord();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// [GoogleSignInAuthentication]
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Sign In with Google
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      final userController = Get.put(UserController());
      // Save Authenticated user data in the Firebase Firestore
      await userController.saveUserRecord(userCredentials: userCredentials);

      Get.put(CreateNotificationController());
      await CreateNotificationController.instance.createNotification();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials?.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
