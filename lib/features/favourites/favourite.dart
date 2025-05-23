import 'package:cwt_starter_template/common/widgets/appbar/home_appbar.dart';
import 'package:cwt_starter_template/features/dashboard/course/screens/dashboard/coursesDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../products/controllers/product_controller.dart';
import '../products/screens/product_cards/product_card_vertical.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TEComAppBar(
        showBackArrow: true,
        title: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
        actions: [TCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(() => const CoursesDashboard()))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [

              /// Products Grid
              Obx(() {
                final products = ProductController.instance.favoriteProducts();
                return TGridLayout(
                  itemCount: products.length,
                  itemBuilder: (_, index) => TProductCardVertical(product: products[index]),
                );
              }),
              SizedBox(height: TDeviceUtils.getBottomNavigationBarHeight() + TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
