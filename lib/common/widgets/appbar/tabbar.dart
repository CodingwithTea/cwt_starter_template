import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

/// A custom tab bar widget with customizable appearance.
class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor for the TTabBar.
  ///
  /// Parameters:
  ///   - tabs: List of widgets representing the tabs.
  const TTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.black : TColors.white, // Background color of the tab bar
      child: TabBar(
        tabs: tabs, // List of tabs
        isScrollable: true, // Enable scrollable tabs
        indicatorColor: TColors.primary, // Color of the tab indicator
        labelColor: dark ? TColors.white : TColors.primary, // Color of the selected tab label
        unselectedLabelColor: TColors.darkGrey, // Color of unselected tab labels
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight()); // Preferred size of the tab bar
}