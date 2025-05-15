import 'package:cwt_starter_template/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Container(
      padding: const EdgeInsets.only(top: TSizes.xl - 15, bottom: TSizes.xl),
      child: Form(
        key: controller.signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              validator: (value) {
                if (value!.isEmpty) return 'Name cannot be empty';
                return null;
              },
              decoration: const InputDecoration(label: Text(tFullName), prefixIcon: Icon(LineAwesomeIcons.user)),
            ),
            const SizedBox(height: TSizes.xl - 20),
            TextFormField(
              controller: controller.email,
              validator:  (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(label: Text(tEmail), prefixIcon: Icon(LineAwesomeIcons.envelope)),
            ),
            const SizedBox(height: TSizes.xl - 20),
            TextFormField(
              controller: controller.phoneNo,
              validator: (value) {
                if (value!.isEmpty) return 'Phone number cannot be empty';
                return null;
              },
              decoration: InputDecoration(label: Text(tPhoneNo), prefixIcon: Icon(LineAwesomeIcons.phone_solid)),
            ),
            const SizedBox(height: TSizes.xl - 20),
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => TValidator.validatePassword(value),
                obscureText: controller.showPassword.value ? false : true,
                decoration: InputDecoration(
                  label: const Text(tPassword),
                  prefixIcon: const Icon(Icons.fingerprint),
                  suffixIcon: IconButton(
                    icon: controller.showPassword.value ? const Icon(LineAwesomeIcons.eye) : const Icon(LineAwesomeIcons.eye_slash),
                    onPressed: () => controller.showPassword.value = !controller.showPassword.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.xl - 10),
            Obx(
              () => TPrimaryButton(
                isLoading: controller.isLoading.value ? true : false,
                text: tSignup.tr,
                onPressed:
                    controller.isFacebookLoading.value || controller.isGoogleLoading.value
                        ? () {}
                        : controller.isLoading.value
                        ? () {}
                        : () => controller.createUser(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
