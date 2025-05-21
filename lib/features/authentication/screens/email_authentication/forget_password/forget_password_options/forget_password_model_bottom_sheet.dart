import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../forget_password_mail/forget_password_mail.dart';
import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TTexts.tForgetPasswordTitle, style: Theme.of(context).textTheme.displayMedium),
                Text(TTexts.tForgetPasswordSubTitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 30.0),
                ForgetPasswordBtnWidget(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const ForgetPasswordMailScreen());
                  },
                  title: TTexts.tEmail,
                  subTitle: TTexts.tResetViaEMail,
                  btnIcon: Icons.mail_outline_rounded,
                ),
                const SizedBox(height: 20.0),
                ForgetPasswordBtnWidget(onTap: () {}, title: TTexts.tPhoneNo, subTitle: TTexts.tResetViaPhone, btnIcon: Icons.mobile_friendly_rounded),
              ],
            ),
          ),
    );
  }
}
