import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../data/repository/user_repository/user_repository.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final showPassword = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// Loader
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  /// [EmailAndPasswordLogin]
  Future<void> login() async {
    try {
      isLoading.value = true;
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      final auth = AuthenticationRepository.instance;
      await auth.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }

  /// [GoogleSignInAuthentication]
  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;
      // Sign In with Google
      await auth.signInWithGoogle();
      // Once the user Signed In, Check if the User Data is already stored in Firestore Collection('Users')
      // If not store the data and let the user Login.
      // [auth.getUserEmail] will return current LoggedIn user email.
      // If record does not exit -> Create new
      /// --  In this case or any case do not store password in the Firestore. This is just for learning purpose.
      if (!await UserRepository.instance.recordExist(auth.getUserEmail)) {
        UserModel user = UserModel(email: auth.getUserEmail, password: '', fullName: auth.getDisplayName, phoneNo: auth.getPhoneNo);
        await UserRepository.instance.createUser(user);
      }
      isGoogleLoading.value = false;
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }

  /// [FacebookSignInAuthentication]
  Future<void> facebookSignIn() async {
    try {
      isFacebookLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.signInWithFacebook();

      /// --  In this case or any case do not store password in the Firestore. This is just for learning purpose.
      if (!await UserRepository.instance.recordExist(auth.getUserID)) {
        UserModel user = UserModel(email: auth.getUserEmail, password: '', fullName: auth.getDisplayName, phoneNo: auth.getPhoneNo);
        await UserRepository.instance.createUser(user);
      }
      isFacebookLoading.value = false;
    } catch (e) {
      isFacebookLoading.value = false;
      Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }
}
