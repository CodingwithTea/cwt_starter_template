import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../personalization/controllers/user_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

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
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Drawer header showing account information centered in a row
          GestureDetector(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: Image(image: AssetImage(TImages.tLogoImage)),
              currentAccountPictureSize: Size(100, 100),
              accountName: Text(userController.user.value.fullName),
              accountEmail: Text(userController.user.value.email),
            ),
            onTap: () => Get.toNamed(TRoutes.profileScreen),
          ),

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
      _buildDrawerItem(icon: Icons.home, title: "E-Commerce Dashboard", onTap: ()  => Get.toNamed(TRoutes.eComDashboard)),
      _buildDrawerItem(icon: Icons.add_shopping_cart, title: "Cart", onTap: ()  => Get.toNamed(TRoutes.cartScreen)),
      _buildDrawerItem(icon: Icons.shopping_bag, title: "Checkout", onTap: ()  => Get.toNamed(TRoutes.checkoutScreen)),
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
