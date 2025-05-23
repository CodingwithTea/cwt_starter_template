import 'package:cwt_starter_template/common/widgets/appbar/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../personalization/screens/profile/profile_screen.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../cart/screens/cart_menu_icon.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TEComAppBar(
      title: GestureDetector(
        onTap: () => Get.to(() => const ProfileScreen()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey)),
            Text(TTexts.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white)),
          ],
        ),
      ),
      actions: const [TCartCounterIcon(iconColor: TColors.white, counterBgColor: TColors.black, counterTextColor: TColors.white)],
    );
  }
}
