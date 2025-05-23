import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../common/widgets/images/t_rounded_image.dart';
import '../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../common/widgets/texts/t_product_title_text.dart';
import '../models/cart_item_model.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
    required this.item,
  });

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        /// 1 - Image
        TRoundedImage(
          width: 60,
          height: 60,
          imageUrl: item.image ?? '',
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: dark ? TColors.darkerGrey : TColors.white,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        /// 2 - Title, Price, & Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Brand and Title
              TBrandTitleWithVerifiedIcon(title: item.brandName ?? ''),
              Flexible(child: TProductTitleText(title: item.title ?? '', maxLines: 1)),

              /// Attributes
              Text.rich(
                TextSpan(
                  children: (item.selectedVariation ?? {}).entries
                      .map(
                        (e) => TextSpan(
                          children: [
                            TextSpan(text: ' ${e.key} ', style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: '${e.value} ', style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
