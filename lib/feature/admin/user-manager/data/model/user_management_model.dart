import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';

class UserManagementModel extends UserManagementEntity {
  const UserManagementModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.role,
    super.currentClass,
    super.teachingClass,
    required super.createdAt,
    super.lastLoginAt,
    required super.isActive,
    super.profile,
  });

  factory UserManagementModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing user: ${json['fullName']} (${json['email']})');
      print('Full JSON data: $json');
      
      // Parse createdAt with fallback
      DateTime createdAt;
      try {
        createdAt = DateTime.parse(json['createdAt']);
      } catch (e) {
        print('Error parsing createdAt: $e, using current time');
        createdAt = DateTime.now();
      }
      
      // Parse lastLoginAt with fallback
      DateTime? lastLoginAt;
      if (json['lastLoginAt'] != null) {
        try {
          lastLoginAt = DateTime.parse(json['lastLoginAt']);
        } catch (e) {
          print('Error parsing lastLoginAt: $e, setting to null');
          lastLoginAt = null;
        }
      }
      
      return UserManagementModel(
        id: json['_id'] ?? json['id'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'student',
        currentClass: json['currentClass'] != null ? json['currentClass']['name'] : null,
        teachingClass: json['teachingClass'] != null ? json['teachingClass']['name'] : null,
        createdAt: createdAt,
        lastLoginAt: lastLoginAt,
        isActive: json['isActive'] ?? true, // Default to true if not provided
        profile: json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null,
      );
    } catch (e) {
      print('Error parsing user JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'role': role,
      'currentClass': currentClass,
      'teachingClass': teachingClass,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
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
      avatar: json['avatar'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      gender: json['gender'],
      address: json['address'],
      notification: json['notification'],
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

