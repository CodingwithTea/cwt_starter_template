import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../data/services/notifications/notification_model.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../controllers/notification_controller.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NotificationController());
    controller.selectedNotification.value = Get.arguments ?? NotificationModel.empty();
    controller.selectedNotificationId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Notification'),
        showSkipButton: false,
        showActions: false,
        showBackArrow: true,
        leadingOnPressed: () => Get.offNamed(TRoutes.notification),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TRoundedContainer(
            backgroundColor: dark ? TColors.dark : TColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.selectedNotification.value.type.isNotEmpty)
                  TRoundedContainer(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.sm, horizontal: TSizes.sm),
                    backgroundColor: TColors.primary,
                    child: Text(controller.selectedNotification.value.type, style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.black)),
                  ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text('Title', style: Theme.of(context).textTheme.labelMedium),
                Text(
                  controller.selectedNotification.value.title,
                  style: Theme.of(context).textTheme.titleMedium!.apply(color: dark ? Colors.white : Colors.blue),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text('Message', style: Theme.of(context).textTheme.labelMedium),
                Text(controller.selectedNotification.value.body, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Notification Click event
                if (controller.selectedNotification.value.route.isNotEmpty &&
                    controller.selectedNotification.value.route != TRoutes.notification &&
                    controller.selectedNotification.value.route != TRoutes.notificationDetails)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => Get.toNamed(controller.selectedNotification.value.route, parameters: {'id': controller.selectedNotification.value.routeId}),
                      label: const Text('Redirect'),
                      icon: const Icon(Iconsax.arrow_right),
                    ),
                  ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          );
        }),
      ),
    );
  }
}
