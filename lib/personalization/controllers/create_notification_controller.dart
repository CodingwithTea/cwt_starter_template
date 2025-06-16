import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../data/repository/notifications/notification_repository.dart';
import '../../data/services/notifications/notification_model.dart';
import '../../utils/helpers/network_manager.dart';
import '../../utils/popups/loaders.dart';
import 'notification_controller.dart';

class CreateNotificationController extends GetxController {
  static CreateNotificationController get instance => Get.isRegistered() ? Get.find() : Get.put(CreateNotificationController());

  final isLoading = false.obs;

  final notificationController = Get.put(NotificationController());
  final repository = Get.put(NotificationRepository());

  /// Register new Notification
  Future<void> createNotification() async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      final userController = Get.put(UserController());

      final user = await userController.userRepository.fetchUserDetails();

      // Map Data
      final newRecord = NotificationModel(
        id: '',
        title: "Welcome to Coding with T!",
        body: "Your account has been successfully created. Start exploring our features and enjoy your app development journey with us.",
        senderId: userController.user.value.id,
        recipientIds: [user.id],
        type: 'Account',
        routeId: '',
        isBroadcast: true,
        route: TRoutes.notificationDetails,
        seenBy: {},
        seenAt: null,
        createdAt: DateTime.now(),
      );

      // Call Repository to Create New Notification
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      notificationController.notifications.insert(0, newRecord);
      notificationController.notifications.refresh();

      // Remove Loader
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
