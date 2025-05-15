import 'package:flutter/material.dart';

import '../../../../../../common/widgets/form/form_header_widget.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: TSizes.defaultSpace * 4),
                FormHeaderWidget(
                  imageColor: isDark ? TColors.primary : TColors.secondary,
                  image: tForgetPasswordImage,
                  title: tForgetPassword,
                  subTitle: tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.xl),
                Form(
                  child: Column(
                    children: [
                      TextFormField(decoration: const InputDecoration(label: Text(tPhoneNo), hintText: tPhoneNo, prefixIcon: Icon(Icons.numbers))),
                      const SizedBox(height: 20.0),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(tNext))),
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
