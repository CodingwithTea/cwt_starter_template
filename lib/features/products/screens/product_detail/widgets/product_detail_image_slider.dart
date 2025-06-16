import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product_controller.dart';
import '../../../models/product_model.dart';
import '../../favourite_icon.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    final images = controller.getAllProductImages(product);
    return TCurvedEdgesWidget(
      child: Container(
        color: isDark ? TColors.darkerGrey : TColors.white,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace * 2),
                child: Center(
                  child: Obx(() {
                    final image = controller.selectedProductImage.value.isEmpty ? product.thumbnail : controller.selectedProductImage.value;
                    return GestureDetector(onTap: () => controller.showEnlargedImage(image), child: Image(image: AssetImage(image), fit: BoxFit.contain));
                  }),
                ),
              ),
            ),

            /// Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    return Obx(() {
                      final imageSelected = controller.selectedProductImage.value == images[index];
                      return TRoundedImage(
                        width: 80,
                        fit: BoxFit.contain,
                        imageUrl: images[index],
                        padding: const EdgeInsets.all(TSizes.sm),
                        backgroundColor: isDark ? TColors.dark : TColors.white,
                        onPressed: () => controller.selectedProductImage.value = images[index],
                        border: Border.all(color: imageSelected ? TColors.primary : Colors.transparent),
                      );
                    });
                  },
                ),
              ),
            ),

            /// Appbar Icons
            TAppBar(showBackArrow: true, 
                actions: [TFavouriteIcon(productId: product.id)], showActions: true, showSkipButton: false,),
          ],
        ),
      ),
    );
  }
}
