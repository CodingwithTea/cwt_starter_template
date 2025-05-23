import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/controllers/address_controller.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  final String name, phoneNumber, address;

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TSectionHeading(title: 'Shipping Address', buttonTitle: 'Change', showActionButton: true, onPressed: () => addressController.selectNewAddress(context)),
          Text(addressController.selectedAddress.value.name, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: TSizes.spaceBtwItems/2),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(addressController.selectedAddress.value.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems/2),
          Row(
            children: [
              const Icon(Icons.location_history, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(child: Text(addressController.selectedAddress.value.toString(), style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
            ],
          ),
        ],
      ),
    );
  }
}
