import 'package:get/get.dart';

import '../../../constants/text_strings.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../../../utils/helper/helper_controller.dart';
import '../../authentication/models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  /// Repositories
  final _authRepo = AuthenticationRepository.instance;
  final _userRepo = UserRepository.instance;

  /// Get User Email and pass to UserRepository to fetch user record.
  getUserData() async {
    try {
      final currentUserEmail = _authRepo.getUserEmail;
      if (currentUserEmail.isNotEmpty) {
        return await _userRepo.getUserDetails(currentUserEmail);
      } else {
        Helper.warningSnackBar(title: 'Error', message: 'No user found!');
        return;
      }
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Fetch List of user records.
  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  /// Update User Data
  updateRecord(UserModel user) async {
    try {
      await _userRepo.updateUserRecord(user);
      //Show some message or redirect to other screen here...
      Helper.successSnackBar(title: tCongratulations, message: 'Profile Record has been updated!');
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      String uID = _authRepo.getUserID;
      if (uID.isNotEmpty) {
        await _userRepo.deleteUser(uID);
        // You can Logout() or move to other screen here...
        Helper.successSnackBar(title: tCongratulations, message: 'Account has been deleted!');
      } else {
        Helper.successSnackBar(title: 'Error', message: 'User cannot be deleted!');
      }
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
