import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../styles/spacing_styles.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Custom appbar for achieving a desired design goal.
  /// - Set [title] for a custom title.
  /// - [showBackArrow] to toggle the visibility of the back arrow.
  /// - [leadingIcon] for a custom leading icon.
  /// - [leadingOnPressed] callback for the leading icon press event.
  /// - [actions] for adding a list of action widgets.
  /// - Horizontal padding of the appbar can be customized inside this widget.
  const TAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showActionWithBadge = false,
    this.showBackArrow = false,
    required this.showActions,
    required this.showSkipButton,
    this.actionIcon,
    this.actionOnPressed,
    this.centerTitle = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final bool showActions;
  final bool showSkipButton;
  final bool showActionWithBadge;
  final bool centerTitle;
  final IconData? leadingIcon;
  final IconData? actionIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback? actionOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: TSpacingStyle.paddingWithDefaultWidth,
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        automaticallyImplyLeading: false,
        leading:
            showBackArrow
                ? IconButton(onPressed: () => Get.back(result: true), icon: Icon(Iconsax.arrow_left_24, color: dark ? TColors.white : TColors.dark))
                : leadingIcon != null
                ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon, color: dark ? TColors.white : TColors.dark))
                : null,
        title: title,
        actions:
            showSkipButton
                ? [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(6), textStyle: Theme.of(context).textTheme.bodySmall),
                    child: const Text(TTexts.skip),
                  ),
                ]
                : showActions
                ? (actions != null)
                    ? actions
                    : [
                      showActionWithBadge
                          ? badges.Badge(
                            position: badges.BadgePosition.topEnd(top: 0, end: 0),
                            badgeStyle: const badges.BadgeStyle(badgeColor: TColors.primary),
                            // badgeContent: Obx(() => Text(controller.cartItems.length.toString(), style: const TextStyle(color: Colors.black))),
                            child: IconButton(onPressed: actionOnPressed, icon: Icon(actionIcon, color: dark ? TColors.white : TColors.dark)),
                          )
                          : IconButton(onPressed: actionOnPressed, icon: Icon(actionIcon, color: dark ? TColors.white : TColors.dark)),
                    ]
                : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
