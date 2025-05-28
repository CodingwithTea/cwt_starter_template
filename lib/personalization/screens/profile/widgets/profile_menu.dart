import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({super.key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = THelperFunctions.isDarkMode(context);
    var iconColor = isDark ? TColors.primary : TColors.accent;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg), color: iconColor.withValues(alpha: 0.1)),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon ? const SizedBox(width: 30, height: 30, child: Icon(LineAwesomeIcons.angle_right_solid, size: 18.0, color: Colors.grey)) : null,
    );
  }
}
