import 'package:flutter/material.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../models/dashboard/courses_model.dart';

class DashboardTopCourses extends StatelessWidget {
  const DashboardTopCourses({super.key, required this.txtTheme});

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    final list = DashboardTopCoursesModel.list;
    final dark = THelperFunctions.isDarkMode(context);
    return SizedBox(
      height: 210,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder:
            (context, index) => GestureDetector(
              onTap: list[index].onPress,
              child: SizedBox(
                width: 320,
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //For Dark Color
                      color: dark ? TColors.secondary : TColors.cardBackgroundColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(list[index].title, style: txtTheme.headlineMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
                            Flexible(child: Image(image: AssetImage(list[index].image), height: 110)),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(style: ElevatedButton.styleFrom(shape: const CircleBorder()), onPressed: () {}, child: const Icon(Icons.play_arrow)),
                            const SizedBox(width: TSizes.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(list[index].heading, style: txtTheme.headlineMedium, overflow: TextOverflow.ellipsis),
                                Text(list[index].subHeading, style: txtTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
