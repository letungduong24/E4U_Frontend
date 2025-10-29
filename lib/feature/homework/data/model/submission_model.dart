import 'package:e4uflutter/feature/homework/domain/entity/submission_entity.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart' as homework_entity;

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
      homework_entity.HomeworkEntity homework;
      if (json['homeworkId'] is Map) {
        final homeworkMap = json['homeworkId'] as Map<String, dynamic>;
        homework = HomeworkModel.fromJson(homeworkMap);
      } else if (json['homeworkId'] is String) {
        // If homeworkId is just an ID string, create a dummy entity
        homework = HomeworkModel(
          id: '',
          title: 'Unknown',
          description: 'Unknown',
          classEntity: const ClassModel(id: '', name: 'Unknown', code: ''),
          teacherEntity: const TeacherModel(id: '', name: 'Unknown'),
          deadline: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        throw Exception('homeworkId must be populated');
      }

      // Parse student - API returns studentId as object with {_id, name, email}
      StudentEntity student;
      String studentIdStr;
      if (json['studentId'] is Map) {
        final studentIdObj = json['studentId'] as Map<String, dynamic>;
        studentIdStr = studentIdObj['_id'] ?? studentIdObj['id'] ?? '';
        student = StudentModel.fromJson(studentIdObj);
      } else if (json['studentId'] is String) {
        // If studentId is just a string, create minimal entity
        studentIdStr = json['studentId'];
        student = StudentModel(
          id: studentIdStr,
          name: 'Student',
          email: '',
        );
      } else {
        // Fallback for null or unexpected types
        studentIdStr = '';
        student = StudentModel(
          id: '',
          name: 'Unknown Student',
          email: '',
        );
      }

      // Parse file - now it's just a string
      String? fileStr;
      if (json['file'] is String) {
        fileStr = json['file'];
      } else if (json['file'] is Map) {
        // If file is an object, extract the filePath
        final fileObj = json['file'] as Map<String, dynamic>;
        fileStr = fileObj['filePath'] ?? fileObj['fileName'];
      }

      return SubmissionModel(
        id: json['_id'] ?? json['id'] ?? '',
        homeworkId: json['homeworkId'] is String ? json['homeworkId'] : homework.id,
        homework: homework,
        studentId: studentIdStr,
        student: student,
        file: fileStr,
        status: json['status'] ?? 'submitted',
        grade: json['grade'],
        feedback: json['feedback'],
        gradedAt: gradedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'homeworkId': homeworkId,
      'studentId': studentId,
      'file': file,
      'status': status,
      'grade': grade,
      'feedback': feedback,
      'gradedAt': gradedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class HomeworkModel extends homework_entity.HomeworkEntity {
  const HomeworkModel({
    required super.id,
    required super.title,
    required super.description,
    required super.classEntity,
    required super.teacherEntity,
    required super.deadline,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    DateTime deadline;
    try {
      deadline = DateTime.parse(json['deadline'] ?? json['dueDate']);
    } catch (e) {
      deadline = DateTime.now();
    }

    DateTime createdAt;
    DateTime updatedAt;
    try {
      createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now();
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    try {
      updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
    } catch (e) {
      updatedAt = DateTime.now();
    }

    homework_entity.ClassEntity classEntity;
    if (json['classId'] is Map) {
      classEntity = ClassModel.fromJson(json['classId']);
    } else if (json['classId'] is String) {
      // API returns classId as just a string ID
      final classIdStr = json['classId'] as String;
      classEntity = ClassModel(id: classIdStr, name: 'Unknown', code: 'Unknown');
    } else {
      classEntity = const ClassModel(id: '', name: 'Unknown', code: 'Unknown');
    }

    homework_entity.TeacherEntity teacherEntity;
    if (json.containsKey('teacherId')) {
      if (json['teacherId'] is Map) {
        teacherEntity = TeacherModel.fromJson(json['teacherId']);
      } else if (json['teacherId'] is String) {
        teacherEntity = TeacherModel(id: json['teacherId'], name: 'Unknown');
      } else {
        teacherEntity = const TeacherModel(id: '', name: 'Unknown');
      }
    } else {
      // API might not return teacherId, use default
      teacherEntity = const TeacherModel(id: '', name: 'Unknown');
    }

    final homeworkId = json['_id'] ?? json['id'] ?? '';
    final title = json['title'] ?? 'No title';
    
    return HomeworkModel(
      id: homeworkId,
      title: title,
      description: json['description'] ?? '',
      classEntity: classEntity,
      teacherEntity: teacherEntity,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
      name: json['fullName'] ?? json['name'] ?? '',
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

class TeacherModel extends homework_entity.TeacherEntity {
  const TeacherModel({required super.id, required super.name});

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(id: json['_id'] ?? json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class ClassModel extends homework_entity.ClassEntity {
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

class FileModel extends homework_entity.FileEntity {
  const FileModel({
    super.fileName,
    super.filePath,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileName: json['fileName'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
    };
  }
}

