import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';

class HomeworkModel extends HomeworkEntity {
  const HomeworkModel({
    required super.id,
    required super.title,
    required super.description,
    required super.deadline,
    required super.createdAt,
    required super.updatedAt,
    super.file,
    required super.classEntity,
    required super.teacherEntity,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse deadlines
      DateTime deadline;
      try {
        deadline = DateTime.parse(json['deadline']);
      } catch (e) {
        deadline = DateTime.now();
      }

      // Parse createdAt with fallback
      DateTime createdAt;
      try {
        createdAt = DateTime.parse(json['createdAt']);
      } catch (e) {
        createdAt = DateTime.now();
      }

      // Parse updatedAt with fallback
      DateTime updatedAt;
      try {
        updatedAt = DateTime.parse(json['updatedAt']);
      } catch (e) {
        updatedAt = DateTime.now();
      }

      // Parse class entity
      ClassEntity classEntity;
      if (json['classId'] is Map) {
        classEntity = ClassModel.fromJson(json['classId']);
      } else if (json['classId'] is String) {
        // If classId is just a string ID
        classEntity = ClassModel(
          id: json['classId'],
          name: 'Unknown',
          code: '',
        );
      } else {
        classEntity = const ClassModel(
          id: '',
          name: 'Unknown',
          code: '',
        );
      }

      // Parse teacher entity
      TeacherEntity teacherEntity;
      if (json['teacherId'] is Map) {
        teacherEntity = TeacherModel.fromJson(json['teacherId']);
      } else if (json['teacherId'] is String) {
        // If teacherId is just a string ID
        teacherEntity = TeacherModel(
          id: json['teacherId'],
          name: 'Teacher',
        );
      } else {
        teacherEntity = const TeacherModel(
          id: '',
          name: 'Unknown',
        );
      }

      // Parse file entity (optional)
      FileEntity? fileEntity;
      if (json['file'] != null && json['file'] is Map) {
        fileEntity = FileModel.fromJson(json['file']);
      }

      return HomeworkModel(
        id: json['_id'] ?? json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        deadline: deadline,
        createdAt: createdAt,
        updatedAt: updatedAt,
        file: fileEntity,
        classEntity: classEntity,
        teacherEntity: teacherEntity,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'file': file != null ? (file as FileModel).toJson() : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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

class TeacherModel extends TeacherEntity {
  const TeacherModel({
    required super.id,
    required super.name,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class FileModel extends FileEntity {
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

