import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';

class ImageWithIcon extends StatelessWidget {
  const   ImageWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(width: 120, height: 120, child: ClipRRect(borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage(TImages.tProfileImage)))),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: TColors.primary),
            child: const Icon(LineAwesomeIcons.pencil_alt_solid, color: Colors.black, size: 20),
          ),
        ),
      ],
    );
  }
}
