import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = NotificationController.instance;

    return Scaffold(
      appBar: const TAppBar(title: Text('Notifications'), showSkipButton: false, showActions: false, showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          }

          return ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return TRoundedContainer(
                padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                backgroundColor: notification.seenBy[AuthenticationRepository.instance.getUserID] == true
                    ? Colors.grey.withValues(alpha: 0.15)
                    : Colors.blue.withValues(alpha: 0.15),
                child: Obx(
                  () => ListTile(
                    leading: Icon(Iconsax.notification_bing,
                        color: notification.seenBy[AuthenticationRepository.instance.getUserID] == true
                            ? Colors.grey
                            : Colors.blue),
                    title: Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium!.apply(color: dark ? Colors.white : Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text(notification.formattedDate,
                            style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey)),
                      ],
                    ),
                    trailing: notification.seenBy[AuthenticationRepository.instance.getUserID] == true
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(CupertinoIcons.circle_filled, color: Colors.blue),
                    onTap: () => Get.toNamed(TRoutes.notificationDetails, arguments: notification),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
