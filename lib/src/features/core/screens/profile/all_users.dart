import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../features/authentication/models/user_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../controllers/profile_controller.dart';

class AllUsers extends StatelessWidget {
  AllUsers({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text("Users", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("All Users", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20.0),
              FutureBuilder<List<UserModel>>(
                future: controller.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (c, index) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: tPrimaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: const Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide(), right: BorderSide()),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: tPrimaryColor),
                                    child: const Icon(LineAwesomeIcons.user, color: Colors.black),
                                  ),
                                  title: Text(snapshot.data![index].fullName, style: Theme.of(context).textTheme.headlineMedium),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Text(snapshot.data![index].phoneNo), Text(snapshot.data![index].email, overflow: TextOverflow.ellipsis)],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
