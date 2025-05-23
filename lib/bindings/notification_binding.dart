import 'package:get/get.dart';

import '../personalization/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NotificationController());
  }
}