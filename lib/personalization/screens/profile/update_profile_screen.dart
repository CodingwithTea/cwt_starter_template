import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../models/user_model.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../personalization/controllers/user_controller.dart';
import 'profile_form.dart';
import 'widgets/image_with_icon.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text(TTexts.tEditProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),

          /// -- Future Builder to load cloud data
          child: FutureBuilder(
            future: controller.fetchUserRecord(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  //Controllers
                  final email = TextEditingController(text: user.email);
                  // final password = TextEditingController(text: user.password);
                  final fullName = TextEditingController(text: user.fullName);
                  final phoneNo = TextEditingController(text: user.phoneNumber);

                  //Image & Form
                  return Column(
                    children: [
                      /// -- IMAGE with ICON
                      const ImageWithIcon(),
                      const SizedBox(height: 50),

                      /// -- Form (Get data and pass it to FormScreen)
                      // ProfileFormScreen(fullName: fullName, email: email, phoneNo: phoneNo, password: password, user: user),
                      ProfileFormScreen(fullName: fullName, email: email, phoneNo: phoneNo, user: user),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
