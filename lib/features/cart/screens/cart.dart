import 'package:cwt_starter_template/features/cart/screens/widgets/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../common/widgets/appbar/home_appbar.dart';
import '../../checkout/screens/checkout.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      /// -- AppBar
      appBar: TEComAppBar(showBackArrow: true, title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall)),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),

          /// -- Items in Cart
          child: TCartItems(),
        ),
      ),

      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.to(() => const CheckoutScreen()),
            child: Obx(() => Text('Checkout ${controller.totalCartPrice.value}')),
          ),
        ),
      ),
    );
  }
}
