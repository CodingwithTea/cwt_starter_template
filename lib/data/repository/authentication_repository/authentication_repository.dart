import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/authentication/screens/email_authentication/mail_verification/mail_verification.dart';
import '../../../features/authentication/screens/on_boarding/on_boarding_screen.dart';
import '../../../features/authentication/screens/welcome/welcome_screen.dart';
import '../../../src/features/core/screens/dashboard/dashboard.dart';
import 'exceptions/t_exceptions.dart';

/// -- README(Docs[6]) -- Bindings
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;
  final _phoneVerificationId = ''.obs;
  final userStorage = GetStorage(); // Use this to store data locally (e.g. OnBoarding)

  /// Getters
  User? get firebaseUser => _firebaseUser.value;

  String get getUserID => firebaseUser?.uid ?? "";

  String get getUserEmail => firebaseUser?.email ?? "";

  String get getDisplayName => firebaseUser?.displayName ?? "";

  String get getPhoneNo => firebaseUser?.phoneNumber ?? "";

  /// Loads when app Launch from main.dart
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    // ever(_firebaseUser, _setInitialScreen);
  }

  /// Setting initial screen
  setInitialScreen(User? user) async {
    if (user != null) {
      user.emailVerified ? Get.offAll(() => const Dashboard()) : Get.offAll(() => const MailVerification());
    } else {
      // Check if it's the user's first time, then navigate accordingly
      userStorage.writeIfNull('isFirstTime', true);
      print(userStorage.read('isFirstTime'));
      userStorage.read('isFirstTime') != true ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const OnBoardingScreen());
    }

    // Note: As per this code you will not see OnBoarding Screen on app launch.
    // If you want to add that functionality please refer to this tutorial.
    // https://www.youtube.com/watch?v=GYtMpccOOtU&t=78s
  }

  /* ---------------------------- Email & Password sign-in ---------------------------------*/

  /// [EmailAuthentication] - LOGIN
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code); // Throw custom [message] variable
      throw result.message;
    } catch (_) {
      const result = TExceptions();
      throw result.message;
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  /* ---------------------------- Federated identity & social sign-in ---------------------------------*/

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  ///[FacebookAuthentication] - FACEBOOK
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);

      // Create a credential from the access token
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);
      // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Try again!';
    }
  }

  /// [PhoneAuthentication] - LOGIN
  loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      throw e.toString().isEmpty ? 'Unknown Error Occurred. Try again!' : e.toString();
    }
  }

  /// [PhoneAuthentication] - REGISTER
  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          _phoneVerificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _phoneVerificationId.value = verificationId;
        },
        verificationFailed: (e) {
          final result = TExceptions.fromCode(e.code);
          throw result.message;
        },
      );
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      throw e.toString().isEmpty ? 'Unknown Error Occurred. Try again!' : e.toString();
    }
  }

  /// [PhoneAuthentication] - VERIFY PHONE NO BY OTP
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: _phoneVerificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  /* ---------------------------- ./end Federated identity & social sign-in ---------------------------------*/

  /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unable to logout. Try again.';
    }
  }
}
