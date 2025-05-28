import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../personalization/controllers/user_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../images/t_circular_image.dart';

/// A reusable custom drawer widget with predefined settings for account details,
/// menu items, and a "Become a driver" section. The drawer's content is set
/// internally and does not require parameters when used.
class TDrawer extends StatelessWidget {
  /// Creates a [TDrawer] widget.
  ///
  /// The [accountName], [accountEmail], [rating], and [drawerItems] parameters
  /// are used to set the content of the drawer. These values are predefined within
  /// the widget, and no parameters need to be passed when using this widget.
  const TDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final userController = UserController.instance;
    final networkImage = userController.user.value.profilePicture;
    final image = networkImage.isNotEmpty ? networkImage : TImages.tProfileImage;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => Get.toNamed(TRoutes.profileScreen),
            child: Container(
              color: TColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile image
                  TCircularImage(padding: 0, backgroundColor: dark ? TColors.primary : TColors.white, image: image, width: 60, height: 60, isNetworkImage: networkImage.isNotEmpty),
                  const SizedBox(height: 16),
                  // Name
                  Text(userController.user.value.fullName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,color: TColors.dark)),
                  // Email
                  Text(userController.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.dark)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Drawer menu items with predefined values
          ..._drawerItems(),

          const Spacer(),
        ],
      ),
    );
  }

  /// Builds a list of drawer items with predefined values.
  ///
  /// Each item includes an icon, title, and an optional subtitle.
  List<Widget> _drawerItems() {
    return [
      _buildDrawerItem(icon: Icons.verified_user, title: "Profile", onTap: () => Get.toNamed(TRoutes.profileScreen)),
      _buildDrawerItem(icon: Icons.home, title: "E-Commerce Dashboard", onTap: () => Get.toNamed(TRoutes.eComDashboard)),
      _buildDrawerItem(icon: Icons.add_shopping_cart, title: "Cart", onTap: () => Get.toNamed(TRoutes.cartScreen)),
      _buildDrawerItem(icon: Icons.shopping_bag, title: "Checkout", onTap: () => Get.toNamed(TRoutes.checkoutScreen)),
      _buildDrawerItem(icon: Icons.favorite, title: "Wishlist", onTap: () => Get.toNamed(TRoutes.favouritesScreen)),
    ];
  }

  /// Helper method to build a drawer menu item.
  ///
  /// The item includes an icon, title, and an optional subtitle.
  Widget _buildDrawerItem({required IconData icon, required String title, String? subtitle, VoidCallback? onTap}) {
    return ListTile(leading: Icon(icon), title: Text(title), subtitle: subtitle != null ? Text(subtitle) : null, onTap: onTap);
  }
}
