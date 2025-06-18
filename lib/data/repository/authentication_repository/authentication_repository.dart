import 'package:cwt_starter_template/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/authentication/screens/signup/verify_email.dart';
import '../../../features/authentication/screens/welcome/welcome_screen.dart';
import '../../../features/dashboard/course/screens/dashboard/coursesDashboard.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/local_storage/storage_utility.dart';
import '../../../utils/popups/loaders.dart';
import '../user_repository/user_repository.dart';

/// -- README(Docs[6]) -- Bindings
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage(); // Use this to store data locally (e.g. OnBoarding)
  late final Rx<User?> _firebaseUser;
  var phoneNo = ''.obs;
  var phoneNoVerificationId = ''.obs;
  var isPhoneAutoVerified = false;
  final _auth = FirebaseAuth.instance;
  int? _resendToken;

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
    screenRedirect(_firebaseUser.value);
    // ever(_firebaseUser, _setInitialScreen);
  }

  /// Function to Show Relevant Screen
  screenRedirect(User? user) async {
    if (user != null) {
      // Fetch User Record
      await UserController.instance.fetchUserRecord();

      // Use this to check auth Role for admin
      final idTokenResult = await _auth.currentUser!.getIdTokenResult();

      // If email verified let the user go to Home Screen else to the Email Verification Screen
      if (user.emailVerified || user.phoneNumber != null || idTokenResult.claims?['admin'] == true) {
        // Initialize User Specific Storage
        await TLocalStorage.init(user.uid);
        Get.offAll(() => const CoursesDashboard());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: getUserEmail));
      }
    }
    else {
      deviceStorage.writeIfNull('isFirstTime', true);
      final bool isFirstTime = deviceStorage.read('isFirstTime') as bool;

      if (isFirstTime) {
        // First launch: go to OnBoarding
        await Get.offAll(() => const OnBoardingScreen());
        // After showing onboarding, mark it done:
        deviceStorage.write('isFirstTime', false);
      } else {
        // Not first launch: go to Welcome or Login
        Get.offAll(() => const WelcomeScreen());
      }
    }
  }

  /* ---------------------------- Email & Password sign-in ---------------------------------*/

  /// [EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ReAuthenticate] - ReAuthenticate User
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] - FORGET PASSWORD
  Future<void> sendPasswordResetEmail(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
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
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint('Something went wrong: $e');
      return null;
    }
  }

  /* ---------------------------- Phone Number sign-in ---------------------------------*/

  /// [PhoneAuthentication] - LOGIN - Register
  Future<void> loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: _resendToken,
        timeout: const Duration(minutes: 2),
        verificationFailed: (e) async {
          debugPrint('loginWithPhoneNo: verificationFailed => $e');
          await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);

          if (e.code == 'too-many-requests') {
            // Get.offAllNamed(TRoutes.welcome);
            Get.offAll(() => const WelcomeScreen());
            TLoaders.warningSnackBar(title: 'Too many attempts', message: 'Oops! Too many tries. Take a short break and try again soon!');
            return;
          } else if (e.code == 'unknown') {
            Get.back(result: false);
            TLoaders.warningSnackBar(title: 'SMS not Sent', message: 'An internal error has occurred, We are working on it!');
            return;
          }
          TLoaders.warningSnackBar(title: 'Oh Snap', message: e.message ?? '');
        },
        codeSent: (verificationId, resendToken) {
          debugPrint('--------------- codeSent');
          phoneNoVerificationId.value = verificationId;
          _resendToken = resendToken;
          debugPrint('--------------- codeSent: $verificationId');
        },
        verificationCompleted: (credential) async {
          debugPrint('--------------- verificationCompleted');
          var signedInUser = await _auth.signInWithCredential(credential);
          isPhoneAutoVerified = signedInUser.user != null;

          // await screenRedirect(
          //   _auth.currentUser,
          //   pinScreen: true,
          //   stopLoadingWhenReady: true,
          //   phoneNumber: phoneNumber,
          // );
          await screenRedirect(_auth.currentUser);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // phoneNoVerificationId.value = verificationId;
          debugPrint('--------------- codeAutoRetrievalTimeout: $verificationId');
        },
      );
      phoneNo.value = phoneNumber;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [PhoneAuthentication] - VERIFY PHONE NO BY OTP
  Future<bool> verifyOTP(String otp) async {
    try {
      final phoneCredentials = PhoneAuthProvider.credential(verificationId: phoneNoVerificationId.value, smsCode: otp);
      var credentials = await _auth.signInWithCredential(phoneCredentials);
      return credentials.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    } finally {
      phoneNo.value = '';
      isPhoneAutoVerified = false;
    }
  }

  ///[FacebookAuthentication] - FACEBOOK
  // Future<UserCredential> signInWithFacebook() async {
  //   try {
  //     // Trigger the sign-in flow
  //     final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);
  //
  //     // Create a credential from the access token
  //     final AccessToken accessToken = loginResult.accessToken!;
  //     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);
  //
  //     // Once signed in, return the UserCredential
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   } on FirebaseAuthException catch (e) {
  //     throw TFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  /* ---------------------------- ./end Federated identity & social sign-in ---------------------------------*/

  /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      // await FacebookAuth.instance.logOut();
      // await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
