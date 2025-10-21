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
  });

  factory UserManagementModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing user: ${json['fullName']} (${json['email']})');
      
      return UserManagementModel(
        id: json['_id'] ?? json['id'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'student',
        currentClass: json['currentClass'] != null ? json['currentClass']['name'] : null,
        teachingClass: json['teachingClass'] != null ? json['teachingClass']['name'] : null,
        createdAt: DateTime.parse(json['createdAt']),
        lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
        isActive: json['isActive'] ?? true, // Default to true if not provided
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

class UserFilterModel extends UserFilterEntity {
  const UserFilterModel({
    super.role,
    super.searchQuery,
    super.classFilter,
    super.isActive,
    super.sortBy,
    super.sortOrder,
  });

  factory UserFilterModel.fromJson(Map<String, dynamic> json) {
    return UserFilterModel(
      role: json['role'],
      searchQuery: json['searchQuery'],
      classFilter: json['classFilter'],
      isActive: json['isActive'],
      sortBy: json['sortBy'],
      sortOrder: json['sortOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'searchQuery': searchQuery,
      'classFilter': classFilter,
      'isActive': isActive,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }
}
