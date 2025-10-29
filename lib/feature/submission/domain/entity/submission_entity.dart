import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart' as homework_entity;

class SubmissionEntity {
  final String id;
  final String homeworkId;
  final homework_entity.HomeworkEntity homework;
  final String studentId;
  final StudentEntity student;
  final String? file; // Changed from FileEntity to String
  final String status; // 'submitted', 'graded'
  final int? grade;
  final String? feedback;
  final DateTime? gradedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubmissionEntity({
    required this.id,
    required this.homeworkId,
    required this.homework,
    required this.studentId,
    required this.student,
    this.file,
    this.status = 'submitted',
    this.grade,
    this.feedback,
    this.gradedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}

class StudentEntity {
  final String id;
  final String name;
  final String email;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

