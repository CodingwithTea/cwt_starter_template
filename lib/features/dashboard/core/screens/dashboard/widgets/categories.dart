import 'package:flutter/material.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../models/dashboard/categories_model.dart';

class DashboardCategories extends StatelessWidget {
  const DashboardCategories({super.key, required this.txtTheme});

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    final list = DashboardCategoriesModel.list;
    return SizedBox(
      height: 45,
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder:
            (context, index) => GestureDetector(
              onTap: list[index].onPress,
              child: SizedBox(
                width: 170,
                height: 45,
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: TColors.dark),
                      child: Center(child: Text(list[index].title, style: txtTheme.titleLarge?.apply(color: Colors.white))),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(list[index].heading, style: txtTheme.titleLarge, overflow: TextOverflow.ellipsis),
                          Text(list[index].subHeading, style: txtTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
