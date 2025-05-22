import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../controllers/mail_verification_controller.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace * 5, left: TSizes.defaultSpace, right: TSizes.defaultSpace, bottom: TSizes.defaultSpace * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LineAwesomeIcons.envelope_open, size: 100),
              const SizedBox(height: TSizes.defaultSpace * 2),
              Text(TTexts.tEmailVerificationTitle.tr, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.defaultSpace),
              Text(TTexts.tEmailVerificationSubTitle.tr, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.defaultSpace * 2),
              SizedBox(width: 200, child: OutlinedButton(child: Text(TTexts.tContinue.tr), onPressed: () => controller.manuallyCheckEmailVerificationStatus())),
              const SizedBox(height: TSizes.defaultSpace * 2),
              TextButton(onPressed: () => controller.sendVerificationEmail(), child: Text(TTexts.tResendEmailLink.tr)),
              TextButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(LineAwesomeIcons.long_arrow_alt_left_solid), const SizedBox(width: 5), Text(TTexts.tBackToLogin.tr.toLowerCase())],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
