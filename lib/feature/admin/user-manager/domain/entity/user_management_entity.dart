class UserManagementEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String role;
  final String? currentClass;
  final String? teachingClass;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final ProfileEntity? profile;

  const UserManagementEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.role,
    this.currentClass,
    this.teachingClass,
    required this.createdAt,
    this.lastLoginAt,
    required this.isActive,
    this.profile,
  });
}

class ProfileEntity {
  final String? avatar;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final bool? notification;

  const ProfileEntity({
    this.avatar,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.notification,
  });
}

class UserFilterEntity {
  final String? role;
  final String? searchQuery;
  final String? classFilter;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const UserFilterEntity({
    this.role,
    this.searchQuery,
    this.classFilter,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });
}
