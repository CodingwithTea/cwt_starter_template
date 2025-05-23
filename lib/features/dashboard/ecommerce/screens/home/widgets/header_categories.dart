import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/image_text/image_text_vertical.dart';
import '../../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controllers/home_controller.dart';

class THeaderCategories extends StatelessWidget {
  const THeaderCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final categories = controller.getFeaturedCategories();
    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Heading
          const TSectionHeading(title: 'Popular Categories', textColor: TColors.white, showActionButton: false),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final category = categories[index];
                return TVerticalImageAndText(
                  image: category.image,
                  title: category.name,
                  onTap: () {},
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
