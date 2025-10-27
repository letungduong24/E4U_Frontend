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
    super.enrollmentHistory,
  });

  // Factory để tạo từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse enrollmentHistory - handle both array of objects and array of strings
    List<EnrollmentEntity>? enrollmentHistory;
    if (json['enrollmentHistory'] is List) {
      final list = json['enrollmentHistory'] as List;
      if (list.isNotEmpty && list.first is Map) {
        // If it's an array of objects, parse normally
        enrollmentHistory = list
            .where((e) => e is Map<String, dynamic>)
            .map((e) => EnrollmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (list.isNotEmpty && list.first is String) {
        // If it's an array of ObjectId strings, skip it (don't parse)
        enrollmentHistory = [];
      }
    }
    
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
      currentClass: json['currentClass'] is Map 
          ? json['currentClass']['name'] 
          : json['currentClass']?.toString(),
      teachingClass: json['teachingClass'] is Map
          ? json['teachingClass']['name']
          : json['teachingClass']?.toString(),
      enrollmentHistory: enrollmentHistory,
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
      'enrollmentHistory': enrollmentHistory,
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

class EnrollmentModel extends EnrollmentEntity {
  const EnrollmentModel({
    required super.className,
    super.completedAt,
    required super.enrolledAt,
    required super.status,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    // Handle both object and string format for class
    String className;
    if (json['class'] is Map) {
      className = json['class']['name']?.toString() ?? '';
    } else if (json['class'] is String) {
      className = json['class'] as String;
    } else {
      className = json['className']?.toString() ?? '';
    }
    
    return EnrollmentModel(
      className: className,
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt']) 
          : null,
      enrolledAt: DateTime.parse(json['enrolledAt']),
      status: json['status'].toString(),
    );
  }

}
