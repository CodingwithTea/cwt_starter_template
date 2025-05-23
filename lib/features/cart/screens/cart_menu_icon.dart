import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/cart_controller.dart';
import 'cart.dart';

/// Custom widget for the cart counter icon
class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    this.iconColor, // Customize icon color
    this.counterBgColor, // Customize counter background color
    this.counterTextColor, // Customize counter text color
  });

  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    // Get an instance of the CartController
    final controller = CartController.instance;

    // Check if the app is in dark mode
    final dark = THelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        // IconButton for navigating to the CartScreen
        IconButton(
          onPressed: () => Get.to(() => const CartScreen()),
          icon: Icon(Iconsax.shopping_bag, color: iconColor),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: TSizes.fontSizeLg,
            height: TSizes.fontSizeLg,
            decoration: BoxDecoration(
              color: counterBgColor ?? (dark ? TColors.white : TColors.black),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Obx(
                () => Text(
                  controller.calculateTotalCartItems(),
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: counterTextColor ?? (dark ? TColors.black : TColors.white),
                        fontSizeFactor: 0.8,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
