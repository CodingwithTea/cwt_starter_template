import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/styles/shadows.dart';
import '../../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../common/widgets/texts/t_product_title_text.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../../models/product_variation_model.dart';
import '../favourite_icon.dart';
import '../product_detail/product_detail.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final salePercentage = ProductController.instance.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),

      /// Container with side paddings, color, edges, radius and shadow.
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail, Wishlist Button, Discount Tag
            TRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.white,
              child: Stack(
                children: [
                  /// -- Thumbnail Image
                  Center(child: TRoundedImage(imageUrl: product.thumbnail, applyImageRadius: true)),

                  /// -- Sale Tag
                  if (salePercentage != null)
                    Positioned(
                      top: 12,
                      child: TRoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: TColors.primary.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                        child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black)),
                      ),
                    ),

                  /// -- Favourite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// -- Details
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: product.title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  TBrandTitleWithVerifiedIcon(title: product.brand!.name, brandTextSize: TextSizes.small),
                ],
              ),
            ),

            /// Price & Add to cart button
            /// Use Spacer() to utilize all the space and set the price and cart button at the bottom.
            /// This usually happens when Product title is in single line or 2 lines (Max)
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Pricing
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Actual Price if sale price not null
                      if (product.productVariations == null && product.salePrice != null && product.salePrice! > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.sm),
                          child: Text(
                            product.price.toString(),
                            style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),
                          ),
                        ),

                      /// Price, Show sale price as main price if sale exist.
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.sm),
                        child: TProductPriceText(price: ProductController.instance.getProductPrice(product)),
                      ),
                    ],
                  ),
                ),

                /// Add to cart
                GestureDetector(
                  onTap: () {
                    // If the product have variations then show the product Details for variation selection.
                    // ELse add product to the cart.
                    if (product.productVariations == null) {
                      cartController.addSingleItemToCart(product, ProductVariationModel.empty());
                    } else {
                      Get.to(() => ProductDetailScreen(product: product));
                    }
                  },
                  child: Obx(
                    () {
                      final productQuantityInCart = cartController.calculateSingleProductCartEntries(product.id, '');

                      return AnimatedContainer(
                        curve: Curves.easeInOutCubicEmphasized,
                        decoration: BoxDecoration(
                          color: productQuantityInCart > 0 ? TColors.dashboardAppbarBackground : TColors.dark,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                            bottomRight: Radius.circular(TSizes.productImageRadius),
                          ),
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: TSizes.iconLg * 1.2,
                          height: TSizes.iconLg * 1.2,
                          child: Center(
                            child: productQuantityInCart > 0
                                ? Text(productQuantityInCart.toString(),
                                    style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.white))
                                : const Icon(Iconsax.add, color: TColors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
