import 'package:e4uflutter/feature/submission/domain/entity/submission_entity.dart';

class SubmissionModel extends SubmissionEntity {
  const SubmissionModel({
    required super.id,
    required super.homeworkId,
    required super.homework,
    required super.studentId,
    required super.student,
    super.file,
    super.status,
    super.grade,
    super.feedback,
    super.gradedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse dates
      DateTime createdAt;
      DateTime updatedAt;
      DateTime? gradedAt;

      try {
        createdAt = DateTime.parse(json['createdAt']);
      } catch (e) {
        createdAt = DateTime.now();
      }

      try {
        updatedAt = DateTime.parse(json['updatedAt']);
      } catch (e) {
        updatedAt = DateTime.now();
      }

      if (json['gradedAt'] != null) {
        try {
          gradedAt = DateTime.parse(json['gradedAt']);
        } catch (e) {
          gradedAt = null;
        }
      }

      // Parse homework
      HomeworkEntity homework;
      if (json['homeworkId'] is Map) {
        homework = HomeworkModel.fromJson(json['homeworkId']);
      } else if (json['homeworkId'] is String) {
        // If homeworkId is just an ID string, create a dummy entity
        homework = HomeworkModel(
          id: '',
          title: 'Unknown',
          description: 'Unknown',
          classEntity: const ClassModel(id: '', name: 'Unknown', code: ''),
          deadline: DateTime.now(),
        );
      } else {
        throw Exception('homeworkId must be populated');
      }

      // Parse student - make it optional since we might not have user details
      StudentEntity student;
      if (json['studentId'] is Map) {
        student = StudentModel.fromJson(json['studentId']);
      } else {
        // If studentId is just a string, create minimal entity
        final studentIdStr = json['studentId'] is String ? json['studentId'] : '';
        student = StudentModel(
          id: studentIdStr,
          name: 'Student',
          email: '',
        );
      }

      // Parse file
      FileEntity? fileEntity;
      if (json['file'] is Map && json['file'] != null) {
        fileEntity = FileModel.fromJson(json['file']);
      }

      return SubmissionModel(
        id: json['_id'] ?? json['id'] ?? '',
        homeworkId: json['homeworkId'] is String ? json['homeworkId'] : homework.id,
        homework: homework,
        studentId: json['studentId'] is String ? json['studentId'] : student.id,
        student: student,
        file: fileEntity,
        status: json['status'] ?? 'submitted',
        grade: json['grade'],
        feedback: json['feedback'],
        gradedAt: gradedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('Error parsing submission JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'homeworkId': homeworkId,
      'studentId': studentId,
      'file': file != null ? (file as FileModel).toJson() : null,
      'status': status,
      'grade': grade,
      'feedback': feedback,
      'gradedAt': gradedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class HomeworkModel extends HomeworkEntity {
  const HomeworkModel({
    required super.id,
    required super.title,
    required super.description,
    required super.classEntity,
    required super.deadline,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    DateTime deadline;
    try {
      deadline = DateTime.parse(json['deadline'] ?? json['dueDate']);
    } catch (e) {
      deadline = DateTime.now();
    }

    ClassEntity classEntity;
    if (json['classId'] is Map) {
      classEntity = ClassModel.fromJson(json['classId']);
    } else if (json['classId'] is String) {
      // If classId is just a string, create a class with that ID
      classEntity = ClassModel(
        id: json['classId'],
        name: 'Unknown',
        code: '',
      );
    } else {
      classEntity = const ClassModel(id: '', name: 'Unknown', code: '');
    }

    return HomeworkModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['description'] ?? 'No title',
      description: json['description'] ?? '',
      classEntity: classEntity,
      deadline: deadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'classId': (classEntity as ClassModel).toJson(),
      'deadline': deadline.toIso8601String(),
    };
  }
}

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
    };
  }
}

class FileModel extends FileEntity {
  const FileModel({
    required super.fileName,
    required super.filePath,
    super.originalName,
    super.fileSize,
    super.mimeType,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      originalName: json['originalName'],
      fileSize: json['fileSize'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'originalName': originalName,
      'fileSize': fileSize,
      'mimeType': mimeType,
    };
  }
}

