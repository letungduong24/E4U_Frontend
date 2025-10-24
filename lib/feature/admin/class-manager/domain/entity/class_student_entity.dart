class ClassStudentEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String classId;
  final String className;
  final String classCode;
  final String enrollmentId;
  final String enrollmentStatus;
  final DateTime enrolledAt;
  final String enrollmentNotes;

  const ClassStudentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.classId,
    required this.className,
    required this.classCode,
    required this.enrollmentId,
    required this.enrollmentStatus,
    required this.enrolledAt,
    required this.enrollmentNotes,
  });
}

class ClassStudentsResponseEntity {
  final String classId;
  final String className;
  final String classCode;
  final String description;
  final int maxStudents;
  final bool isActive;
  final List<ClassStudentEntity> students;

  const ClassStudentsResponseEntity({
    required this.classId,
    required this.className,
    required this.classCode,
    required this.description,
    required this.maxStudents,
    required this.isActive,
    required this.students,
  });
}
