import 'package:cwt_starter_template/common/widgets/images/t_rounded_image.dart';
import 'package:cwt_starter_template/personalization/controllers/theme_controller.dart';
import 'package:cwt_starter_template/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../data/repository/authentication_repository/authentication_repository.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import 'update_profile_screen.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);
    final themeController = ThemeController.instance;
    final userController = UserController.instance;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text(TTexts.tProfile, style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(themeController.isDark.value ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
              onPressed: () => themeController.toggleTheme(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// -- IMAGE with ICON
              // const ImageWithIcon(),
              Stack(
                children: [
                  Obx(() {
                    final networkImage = userController.user.value.profilePicture;
                    final image = networkImage.isNotEmpty ? networkImage : TImages.tProfileImage;
                    return userController.imageUploading.value
                        ? const TShimmerEffect(width: 80, height: 80, radius: 100)
                        : TRoundedImage(width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty,fit: BoxFit.fill, imageUrl: image,borderRadius: 50,);
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: userController.imageUploading.value ? () {} : () => userController.uploadUserProfilePicture(),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: TColors.primary),
                        child: Icon(LineAwesomeIcons.pencil_alt_solid, color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                UserController.instance.user.value.fullName.isEmpty ? TTexts.tProfileHeading : UserController.instance.user.value.fullName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                UserController.instance.user.value.email.isEmpty ? TTexts.tProfileSubHeading : UserController.instance.user.value.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              /// -- BUTTON
              TPrimaryButton(isFullWidth: false, width: 200, text: TTexts.tEditProfile, onPressed: () => Get.to(() => UpdateProfileScreen())),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "E-Commerce Dashboard", icon: Icons.home, onPress: () => Get.toNamed(TRoutes.eComDashboard)),
              ProfileMenuWidget(title: "Cart", icon: Icons.add_shopping_cart, onPress: () => Get.toNamed(TRoutes.cartScreen)),
              ProfileMenuWidget(title: "Checkout", icon: Icons.shopping_bag, onPress: () => Get.toNamed(TRoutes.checkoutScreen)),
              ProfileMenuWidget(title: "Wishlist", icon: Icons.favorite, onPress: () => Get.toNamed(TRoutes.favouritesScreen)),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.sign_out_alt_solid,
                textColor: Colors.red,
                endIcon: false,
                onPress: () => _showLogoutModal(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showLogoutModal() {
    Get.defaultDialog(
      title: "LOGOUT",
      titleStyle: const TextStyle(fontSize: 20),
      content: const Padding(padding: EdgeInsets.symmetric(vertical: 15.0), child: Text("Are you sure, you want to Logout?")),
      confirm: TPrimaryButton(isFullWidth: false, onPressed: () => AuthenticationRepository.instance.logout(), text: "Yes"),
      cancel: SizedBox(width: 100, child: OutlinedButton(onPressed: () => Get.back(), child: const Text("No"))),
    );
  }
}
