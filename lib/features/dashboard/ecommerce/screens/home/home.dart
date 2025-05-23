import 'package:cwt_starter_template/features/dashboard/ecommerce/screens/home/widgets/header_categories.dart';
import 'package:cwt_starter_template/features/dashboard/ecommerce/screens/home/widgets/header_search_container.dart';
import 'package:cwt_starter_template/features/dashboard/ecommerce/screens/home/widgets/home_appbar.dart';
import 'package:cwt_starter_template/features/dashboard/ecommerce/screens/home/widgets/promo_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../cart/controllers/cart_controller.dart';
import '../../../../products/controllers/product_controller.dart';
import '../../../../products/screens/product_cards/product_card_vertical.dart';
import '../../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    Get.put(CartController());
    Get.put(ProductController());
    final featuredProducts = controller.getFeaturedProducts();
    final popularProducts = controller.getPopularProducts();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            const TPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Appbar
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Searchbar
                  TSearchContainer(text: 'Search in Store', showBorder: false),
                  SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Categories
                  THeaderCategories(),
                  SizedBox(height: TSizes.spaceBtwSections * 2),
                ],
              ),
            ),

            /// -- Body
            Container(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Promo Slider 1
                  const TPromoSlider(banners: [TImages.promoBanner1, TImages.promoBanner2, TImages.promoBanner3]),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Popular Products
                  TSectionHeading(
                    title: TTexts.popularProducts,
                    // onPressed: () => Get.to(() => AllProducts(title: TTexts.popularProducts, products: TDummyData.products)),
                    onPressed: () {},
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TGridLayout(itemCount: featuredProducts.length, itemBuilder: (_, index) => TProductCardVertical(product: featuredProducts[index])),
                  const SizedBox(height: TSizes.spaceBtwSections * 2),

                  /// -- Promo Slider 2
                  const TPromoSlider(banners: [TImages.banner2, TImages.banner3, TImages.banner4]),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Popular Products
                  TSectionHeading(title: TTexts.popularProducts, onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TGridLayout(itemCount: popularProducts.length, itemBuilder: (_, index) => TProductCardVertical(product: popularProducts[index])),
                  SizedBox(height: TDeviceUtils.getBottomNavigationBarHeight() + TSizes.defaultSpace),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
