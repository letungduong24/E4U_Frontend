class ClassManagementEntity {
  final String id;
  final String name;
  final String code;
  final String description;
  final String homeroomTeacherId;
  final String? homeroomTeacherName;
  final List<String> studentIds;
  final int maxStudents;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassManagementEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.homeroomTeacherId,
    this.homeroomTeacherName,
    required this.studentIds,
    required this.maxStudents,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ClassFilterEntity {
  final String? searchQuery;
  final String? teacherFilter;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const ClassFilterEntity({
    this.searchQuery,
    this.teacherFilter,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });
}

class StudentClassEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String classId;
  final String className;
  final DateTime enrolledAt;
  final bool isActive;

  const StudentClassEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.className,
    required this.enrolledAt,
    required this.isActive,
  });
}
