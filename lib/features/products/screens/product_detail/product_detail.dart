import 'package:cwt_starter_template/features/products/screens/product_detail/widgets/bottom_add_to_cart_widget.dart';
import 'package:cwt_starter_template/features/products/screens/product_detail/widgets/product_attributes.dart';
import 'package:cwt_starter_template/features/products/screens/product_detail/widgets/product_detail_image_slider.dart';
import 'package:cwt_starter_template/features/products/screens/product_detail/widgets/product_meta_data.dart';
import 'package:cwt_starter_template/features/products/screens/product_detail/widgets/rating_share_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../checkout/screens/checkout.dart';
import '../../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1 - Product Image Slider
            TProductImageSlider(product: product),

            /// 2 - Product Details
            Container(
              padding: const EdgeInsets.only(right: TSizes.defaultSpace, left: TSizes.defaultSpace, bottom: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// - Rating & Share
                  const TRatingAndShare(),

                  /// - Price, Title, Stock, & Brand
                  TProductMetaData(product: product),
                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  /// -- Attributes
                  // If Product has no variations do not show attributes as well.
                  if (product.productVariations != null) TProductAttributes(product: product),
                  if (product.productVariations != null) const SizedBox(height: TSizes.spaceBtwSections),

                  /// -- Checkout Button
                  SizedBox(
                    width: TDeviceUtils.getScreenWidth(context),
                    child: ElevatedButton(child: const Text('Checkout'), onPressed: () => Get.to(() => const CheckoutScreen())),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Description
                  const TSectionHeading(title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Read more package
                  ReadMoreText(
                    product.description!,
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(title: 'Reviews (199)', showActionButton: false),
                      IconButton(
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
