import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_strings.dart';

class TFormDividerWidget extends StatelessWidget {
  const TFormDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Row(
      children: [
        Flexible(child: Divider(thickness: 1, indent: 50, color: Colors.grey.withValues(alpha: 0.3), endIndent: 10)),
        Text(tOR, style: Theme.of(context).textTheme.bodyLarge!.apply(color: isDark ? TColors.white.withValues(alpha: 0.5) : TColors.dark.withValues(alpha: 0.5))),
        Flexible(child: Divider(thickness: 1, indent: 10, color: Colors.grey.withValues(alpha: 0.3), endIndent: 50)),
      ],
    );
  }
}
