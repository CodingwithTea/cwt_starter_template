import '../../../utils/formatters/formatter.dart';

class AddressModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);


  static AddressModel empty() => AddressModel(id: '', name: '', phoneNumber: '', street: '', city: '', state: '', postalCode: '', country: '');



  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}
