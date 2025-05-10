import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../../common_widgets/buttons/primary_button.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../utils/helper/helper_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -- Email Field
            TextFormField(
              validator: Helper.validateEmail,
              controller: controller.email,
              decoration:
                  const InputDecoration(prefixIcon: Icon(LineAwesomeIcons.user), labelText: tEmail, hintText: tEmail),
            ),
            const SizedBox(height: tFormHeight - 20),

            /// -- Password Field
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter your password';
                  return null;
                },
                obscureText: controller.showPassword.value ? false : true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint),
                  labelText: tPassword,
                  hintText: tPassword,
                  suffixIcon: IconButton(
                    icon: controller.showPassword.value
                        ? const Icon(LineAwesomeIcons.eye)
                        : const Icon(LineAwesomeIcons.eye_slash),
                    onPressed: () => controller.showPassword.value = !controller.showPassword.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),

            /// -- FORGET PASSWORD BTN
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => ForgetPasswordScreen.buildShowModalBottomSheet(context),
                child: const Text(tForgetPassword),
              ),
            ),

            /// -- LOGIN BTN
            Obx(
              () => TPrimaryButton(
                isLoading: controller.isLoading.value ? true : false,
                text: tLogin.tr,
                onPressed: controller.isFacebookLoading.value || controller.isGoogleLoading.value
                    ? () {}
                    : controller.isLoading.value
                        ? () {}
                        : () => controller.login(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
