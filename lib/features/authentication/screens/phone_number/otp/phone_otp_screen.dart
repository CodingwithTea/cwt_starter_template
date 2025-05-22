import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/otp_controller.dart';

class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPController.instance;
    controller.init();
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.white,
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TTexts.tOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(TTexts.tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            const Text(TTexts.tOtpMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withValues(alpha: 0.1),
                filled: true,
                onSubmit: (code) {
                  controller.otp = code;
                  OTPController.instance.verifyOTP();
                }),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: controller.loader.value ? () {} : () => controller.verifyOTP(),
                  child: const Text(TTexts.tNext)),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Obx(
                    () => RichText(
                  text: TextSpan(
                    text: TTexts.thenLets,
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: TTexts.resendOTP,
                        recognizer: (controller.secondsRemaining.value > 0) ? null : TapGestureRecognizer()
                          ?..onTap = () => controller.resendOTP(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: (controller.secondsRemaining.value > 0) ? TColors.darkGrey : TColors.primary),
                      ),
                      if (controller.secondsRemaining.value > 0)
                        TextSpan(
                          text: " ${TTexts.inText} ${controller.secondsRemaining.value}",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: TColors.darkGrey),
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         /// Display back button
      //         TRoundedContainer(
      //           padding: EdgeInsets.zero,
      //           backgroundColor: dark ? TColors.iconPrimaryLight : TColors.lightContainer,
      //           child: IconButton(
      //               onPressed: () => Get.back(result: false), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      //         ),
      //
      //         const SizedBox(height: TSizes.spaceBtwSections * 2),
      //
      //         /// Title
      //         Center(
      //           child: Text(TTexts.enter6digitOTPCode.tr,
      //               style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
      //         ),
      //
      //         const SizedBox(height: TSizes.spaceBtwItems),
      //
      //         /// Subtitle123456
      //         Text('${TTexts.otpSubTitle.tr} ${THelperFunctions.maskPhoneNumber(controller.phoneNumber.value)}',
      //             textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
      //
      //         const SizedBox(height: TSizes.spaceBtwSections * 2),
      //
      //         /// OTP Text Field
      //         OTPTextField(
      //           length: 6,
      //           fieldWidth: 50,
      //           outlineBorderRadius: TSizes.borderRadiusLg,
      //           onCompleted: (String verificationCode) => controller.otp = verificationCode,
      //           onChanged: (String code) => controller.otp = code,
      //           fieldStyle: FieldStyle.box,
      //           width: MediaQuery.of(context).size.width,
      //           style: Theme.of(context).textTheme.headlineLarge!.apply(fontSizeDelta: 12),
      //           textFieldAlignment: MainAxisAlignment.spaceAround,
      //           otpFieldStyle: OtpFieldStyle(
      //             borderColor: TColors.primary,
      //             focusBorderColor: dark ? TColors.iconPrimaryLight : TColors.primary,
      //             backgroundColor: dark ? TColors.iconPrimaryLight : TColors.disabledTextLight,
      //             enabledBorderColor: dark ? TColors.iconPrimaryLight : TColors.disabledTextLight,
      //           ),
      //         ),
      //
      //         const SizedBox(height: TSizes.spaceBtwSections * 2),
      //
      //         /// Continue Button
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton(
      //             onPressed: controller.loader.value ? () {} : () => controller.verifyOTP(),
      //             child: Text(controller.loader.value ? 'Verifying...' : TTexts.tContinue.tr),
      //           ),
      //         ),
      //
      //         const SizedBox(height: TSizes.spaceBtwSections * 2),
      //
      //         /// Footer Text
      //         Center(child: Text(TTexts.otpFooter, style: Theme.of(context).textTheme.titleSmall)),
      //
      //         /// Footer text with Button
      //         Center(
      //           child: Obx(
      //             () => RichText(
      //               text: TextSpan(
      //                 text: TTexts.thenLets,
      //                 style: Theme.of(context).textTheme.titleSmall,
      //                 children: [
      //                   TextSpan(
      //                     text: TTexts.resendOTP,
      //                     recognizer: (controller.secondsRemaining.value > 0) ? null : TapGestureRecognizer()
      //                       ?..onTap = () => controller.resendOTP(),
      //                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
      //                         color: (controller.secondsRemaining.value > 0) ? TColors.darkGrey : TColors.primary),
      //                   ),
      //                   if (controller.secondsRemaining.value > 0)
      //                     TextSpan(
      //                       text: " ${TTexts.inText} ${controller.secondsRemaining.value}",
      //                       style: Theme.of(context).textTheme.titleSmall?.copyWith(color: TColors.darkGrey),
      //                     ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}