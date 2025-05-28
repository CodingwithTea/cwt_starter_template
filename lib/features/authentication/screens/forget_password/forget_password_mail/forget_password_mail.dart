import 'package:flutter/material.dart';

import '../../../../../../common/widgets/form/form_header_widget.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final dark = THelperFunctions.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: TSizes.defaultSpace * 4),
                FormHeaderWidget(
                  imageColor: dark ? TColors.primary : TColors.secondary,
                  image: TImages.tForgetPasswordImage,
                  title: TTexts.tForgetPassword,
                  subTitle: TTexts.tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.xl),
                Form(
                  child: Column(
                    children: [
                      TextFormField(decoration: const InputDecoration(label: Text(TTexts.tEmail), hintText: TTexts.tEmail, prefixIcon: Icon(Icons.mail_outline_rounded))),
                      const SizedBox(height: 20.0),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(TTexts.tNext))),
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
