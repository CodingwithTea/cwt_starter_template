import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants/enums.dart';
import '../../utils/formatters/formatter.dart';
import 'address_model.dart';

/// Model class representing user data.
class UserModel {
  final String id;
  String fullName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;

  DateTime? createdAt;
  DateTime? updatedAt;

  bool isProfileActive;
  bool isEmailVerified;
  VerificationStatus verificationStatus;

  String deviceToken;

  final List<AddressModel>? addresses;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.email,
    this.fullName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
    this.deviceToken = '',
    required this.isEmailVerified,
    required this.isProfileActive,
    this.verificationStatus = VerificationStatus.unknown,
    this.addresses,
  });

  /// Helper methods

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  String get formattedDate => TFormatter.formatDateAndTime(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDateAndTime(updatedAt);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() =>
      UserModel(id: '', email: '', isEmailVerified: false, isProfileActive: false); // Default createdAt to current time

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'role': role.name.toString(),
      'isEmailVerified': isEmailVerified,
      'isProfileActive': isProfileActive,
      'deviceToken': deviceToken,
      'verificationStatus': verificationStatus.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt = DateTime.now(),
    };
  }

  // Factory method to create UserModel from Firestore document snapshot
  factory UserModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel.fromJson(doc.id, data);
  }

  // Static method to create a list of UserModel from QuerySnapshot (for retrieving multiple users)
  static UserModel fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(doc.id, data);
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromJson(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data.containsKey('fullName') ? data['fullName'] ?? '' : '',
      email: data.containsKey('email') ? data['email'] ?? '' : '',
      phoneNumber: data.containsKey('phoneNumber') ? data['phoneNumber'] ?? '' : '',
      profilePicture: data.containsKey('profilePicture') ? data['profilePicture'] ?? '' : '',
      role: data.containsKey('role')
          ? (data['role'] ?? AppRole.user) == AppRole.admin.name.toString()
          ? AppRole.admin
          : AppRole.user
          : AppRole.user,
      createdAt: data.containsKey('createdAt') ? data['createdAt']?.toDate() ?? DateTime.now() : DateTime.now(),
      updatedAt: data.containsKey('updatedAt') ? data['updatedAt']?.toDate() ?? DateTime.now() : DateTime.now(),
      deviceToken: data.containsKey('deviceToken') ? data['deviceToken'] ?? '' : '',
      isEmailVerified: data.containsKey('isEmailVerified') ? data['isEmailVerified'] ?? false : false,
      isProfileActive: data.containsKey('isProfileActive') ? data['isProfileActive'] ?? false : false,
      verificationStatus: data.containsKey('verificationStatus')
          ? _mapVerificationStringToEnum(data['verificationStatus'] ?? '')
          : VerificationStatus.pending,
    );
  }

  // Utility to map a role string to the Roles enum
  static VerificationStatus _mapVerificationStringToEnum(String verification) {
    switch (verification) {
      case 'pending':
        return VerificationStatus.pending;
      case 'approved':
        return VerificationStatus.approved;
      case 'rejected':
        return VerificationStatus.rejected;
      case 'submitted':
        return VerificationStatus.submitted;
      case 'underReview':
        return VerificationStatus.underReview;
      default:
        return VerificationStatus.unknown;
    }
  }
}
