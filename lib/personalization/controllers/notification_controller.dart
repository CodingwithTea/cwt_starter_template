import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/services/notifications/notification_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/popups/loaders.dart';
import '../../data/repository/authentication_repository/authentication_repository.dart';
import '../../data/repository/notifications/notification_repository.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.isRegistered() ? Get.find() : Get.put(NotificationController());

  final isLoading = false.obs;
  final selectedNotification = NotificationModel.empty().obs;
  final selectedNotificationId = ''.obs;

  StreamSubscription? _notificationsSubscription;
  final repository = Get.put(NotificationRepository());
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  @override
  void onInit() {
    super.onInit();
    listenToNotifications();
  }

  /// Init Data
  Future<void> init() async {
    try {
      isLoading.value = true;

      // Fetch record if argument was null
      if (selectedNotification.value.id.isEmpty) {
        if (selectedNotificationId.isEmpty) {
          Get.offNamed(TRoutes.notification);
        } else {
          selectedNotification.value = await repository.fetchSingleItem(selectedNotificationId.value);
        }
      }

      if (selectedNotification.value.id.isNotEmpty) await markNotificationAsViewed(selectedNotification.value);
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TLoaders.errorSnackBar(title: 'Oh Snap', message: 'Unable to fetch Notification details. Try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void listenToNotifications() {
    _notificationsSubscription = repository.fetchAllItemsAsStream().listen((notificationList) {
      notifications.value = notificationList; // Update the notifications list in real-time
    }, onError: (error) {
      TLoaders.warningSnackBar(title: "Error", message: "Failed to fetch notifications: $error");
    });
  }

  Future<void> fetchNotifications() async {
    try {
      final result = await repository.fetchAllItems();
      notifications.value = result;
    } catch (e) {
      TLoaders.warningSnackBar(title: "Error", message: "Failed to fetch notifications: $e");
    }
  }

  Future<void> markNotificationAsViewed(NotificationModel notification) async {
    try {
      final String notificationId = notification.id;
      final String currentUserId = AuthenticationRepository.instance.getUserID;

      if (notification.seenBy.isEmpty || notification.seenBy[currentUserId] == false) {
        await repository.markNotificationAsSeen(notificationId, currentUserId);

        notifications.firstWhere((n) => n.id == notification.id).seenBy[currentUserId] = true;
        notifications.refresh();
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: "Error", message: "Unable to mark notification as Seen: $e");
    }
  }

  @override
  void onClose() {
    _notificationsSubscription?.cancel(); // Cancel the subscription when the widget is destroyed
    super.onClose();
  }
}
