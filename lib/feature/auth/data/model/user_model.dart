import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.role,
    super.profile,
    super.currentClass,
    super.teachingClass,
  });

  // Factory để tạo từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'])
          : null,
      currentClass: json['currentClass'] != null
          ? (json['currentClass'] is Map ? json['currentClass']['name'] : json['currentClass'].toString())
          : null,
      teachingClass: json['teachingClass'] != null
          ? (json['teachingClass'] is Map ? json['teachingClass']['name'] : json['teachingClass'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'role': role,
      'profile': (profile is ProfileModel)
          ? (profile as ProfileModel).toJson()
          : null,
      'currentClass': currentClass,
      'teachingClass': teachingClass,
    };
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.avatar,
    super.phone,
    super.dateOfBirth,
    super.gender,
    super.address,
    super.notification,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      avatar: json['avatar']?.toString(),
      phone: json['phone']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender']?.toString(),
      address: json['address']?.toString(),
      notification: json['notification'] is bool ? json['notification'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
      'notification': notification,
    };
  }
}

