import 'package:flutter/material.dart';

import '../../../../../personalization/controllers/user_controller.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import 'widgets/appbar.dart';
import 'widgets/banners.dart';
import 'widgets/categories.dart';
import 'widgets/search.dart';
import 'widgets/top_courses.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    //Variables
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark; //Dark mode
    final controller = UserController.instance;


    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(isDark: isDark),

        /// Create a new Header
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Image(image: AssetImage(TImages.tLogoImage)),
                currentAccountPictureSize: Size(100, 100),
                accountName: Text(controller.user.value.fullName),
                accountEmail: Text(controller.user.value.email),
              ),
              ListTile(leading: Icon(Icons.home), title: Text('Home')),
              ListTile(leading: Icon(Icons.verified_user), title: Text('Profile')),
              ListTile(leading: Icon(Icons.shopping_bag), title: Text('Shop')),
              ListTile(leading: Icon(Icons.favorite), title: Text('Wishlist')),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Heading
                Text(TTexts.tDashboardTitle, style: txtTheme.bodyMedium),
                Text(TTexts.tDashboardHeading, style: txtTheme.displayMedium),
                const SizedBox(height: TSizes.lg),

                //Search Box
                DashboardSearchBox(txtTheme: txtTheme),
                const SizedBox(height: TSizes.lg),

                //Categories
                DashboardCategories(txtTheme: txtTheme),
                const SizedBox(height: TSizes.lg),

                //Banners
                DashboardBanners(txtTheme: txtTheme, isDark: isDark),
                const SizedBox(height: TSizes.lg),

                //Top Course
                Text(TTexts.tDashboardTopCourses, style: txtTheme.headlineMedium?.apply(fontSizeFactor: 1.2)),
                DashboardTopCourses(txtTheme: txtTheme, isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
