import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../images/t_circular_image.dart';
import '../texts/t_brand_title_text.dart';

class TVerticalImageAndText extends StatelessWidget {
  const TVerticalImageAndText({
    super.key,
    this.onTap,
    required this.image,
    required this.title,
    this.backgroundColor,
    this.textColor = TColors.white,
  });

  final Color textColor;
  final String image, title;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            /// Circular Icon
            TCircularImage(
              image: image,
              fit: BoxFit.fitWidth,
              padding: TSizes.sm * 1.4,
              backgroundColor: backgroundColor,
              overlayColor: dark ? TColors.white : TColors.dark,
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// Text
            SizedBox(
              width: 55,
              child: TBrandTitleText(title: title, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
