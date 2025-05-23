import 'package:get/get.dart';

import '../personalization/controllers/notifcation_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NotificationController());
  }
}