import 'package:cwt_starter_template/common/widgets/appbar/home_appbar.dart';
import 'package:cwt_starter_template/features/checkout/screens/widgets/billing_address_section.dart';
import 'package:cwt_starter_template/features/checkout/screens/widgets/billing_payment_section.dart';
import 'package:cwt_starter_template/personalization/controllers/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/helpers/pricing_calculator.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/widgets/cart_items.dart';
import '../../dashboard/ecommerce/controllers/dummy_data.dart';
import 'billing_amount_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    Get.put(AddressController());
    final subTotal = cartController.totalCartPrice.value;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TEComAppBar(title: Text('Order Review'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// -- Items in Cart
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Coupon TextField
              // const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Billing Section
              TRoundedContainer(
                borderColor: TColors.dashboardAppbarBackground,
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    /// Pricing
                    TBillingAmountSection(subTotal: subTotal),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Payment Methods
                    const TBillingPaymentSection(),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Address
                    TBillingAddressSection(
                      name: TDummyData.user.fullName,
                      phoneNumber: TDummyData.user.formattedPhoneNo,
                      address: TDummyData.user.addresses.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),

      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, child: Text('Checkout \$${TPricingCalculator.calculateTotalPrice(subTotal, 'US')}')),
        ),
      ),
    );
  }
}
