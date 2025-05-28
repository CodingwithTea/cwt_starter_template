import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../personalization/controllers/user_controller.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Form(
      key: controller.updateUserProfileFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.fullName,
            decoration: const InputDecoration(label: Text(TTexts.tFullName), prefixIcon: Icon(LineAwesomeIcons.user)),
          ),
          const SizedBox(height: TSizes.xl - 20),
          TextFormField(
            enabled: controller.email.text.isEmpty ? true : false,
            controller: controller.email,
            decoration: const InputDecoration(label: Text(TTexts.tEmail), prefixIcon: Icon(LineAwesomeIcons.envelope)),
          ),
          const SizedBox(height: TSizes.xl - 20),
          TextFormField(
            enabled: controller.phoneNo.text.isEmpty ? true : false,
            controller: controller.phoneNo,
            decoration: const InputDecoration(label: Text(TTexts.tPhoneNo), prefixIcon: Icon(LineAwesomeIcons.phone_solid)),
          ),
          const SizedBox(height: TSizes.xl),

          /// -- Form Submit Button
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.updateUserProfile(), child: const Text(TTexts.tEditProfile))),
          const SizedBox(height: TSizes.xl),

          /// -- Created Date and Delete Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: TTexts.tJoined,
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(
                      text: THelperFunctions.getFormattedDate(controller.user.value.createdAt!),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.deleteAccountWarningPopup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                  elevation: 0,
                  foregroundColor: Colors.red,
                  side: BorderSide.none,
                ),
                child: const Text(TTexts.tDelete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
