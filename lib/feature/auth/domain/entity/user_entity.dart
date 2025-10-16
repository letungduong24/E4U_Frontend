class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String role;
  final ProfileEntity? profile;
  final String? currentClass;
  final String? teachingClass;
  final List<EnrollmentEntity>? enrollmentHistory;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.role,
    this.profile,
    this.currentClass,
    this.teachingClass,
    this.enrollmentHistory,
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

class EnrollmentEntity {
  final String className;
  final String status;
  final DateTime completedAt;
  final DateTime enrolledAt;

  const EnrollmentEntity({
    required this.className,
    required this.status,
    required this.completedAt,
    required this.enrolledAt,
  });
}