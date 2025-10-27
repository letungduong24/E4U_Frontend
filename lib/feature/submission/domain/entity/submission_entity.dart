class SubmissionEntity {
  final String id;
  final String homeworkId;
  final HomeworkEntity homework;
  final String studentId;
  final StudentEntity student;
  final FileEntity? file;
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

class HomeworkEntity {
  final String id;
  final String title;
  final String description;
  final ClassEntity classEntity;
  final DateTime deadline;

  const HomeworkEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.classEntity,
    required this.deadline,
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

class ClassEntity {
  final String id;
  final String name;
  final String code;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.code,
  });
}

class FileEntity {
  final String fileName;
  final String filePath;
  final String? originalName;
  final int? fileSize;
  final String? mimeType;

  const FileEntity({
    required this.fileName,
    required this.filePath,
    this.originalName,
    this.fileSize,
    this.mimeType,
  });
}

