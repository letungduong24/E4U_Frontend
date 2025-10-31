import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';

class DocumentManagementModel extends DocumentManagementEntity {
  const DocumentManagementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.classEntity,
    required super.teacherEntity,
    required super.file,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DocumentManagementModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse createdAt with fallback
      DateTime createdAt;
      try {
        createdAt = DateTime.parse(json['createdAt']);
      } catch (e) {
        print('Error parsing createdAt: $e, using current time');
        createdAt = DateTime.now();
      }

      // Parse updatedAt with fallback
      DateTime updatedAt;
      try {
        updatedAt = DateTime.parse(json['updatedAt']);
      } catch (e) {
        print('Error parsing updatedAt: $e, using current time');
        updatedAt = DateTime.now();
      }

      // Parse class entity
      ClassEntity classEntity;
      if (json['classId'] is Map) {
        classEntity = ClassModel.fromJson(json['classId']);
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
      } else if (json['teacherId'] is String && (json['teacherId'] as String).isNotEmpty) {
        // teacherId is just a string ID
        teacherEntity = TeacherModel(
          id: json['teacherId'] as String,
          name: 'Unknown',
        );
      } else {
        teacherEntity = const TeacherModel(
          id: '',
          name: 'Unknown',
        );
      }

      // Parse file entity
      FileEntity fileEntity;
      if (json['file'] is Map) {
        fileEntity = FileModel.fromJson(json['file']);
      } else {
        fileEntity = const FileModel(
          fileName: '',
          filePath: '',
        );
      }

      return DocumentManagementModel(
        id: json['_id'] ?? json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        classEntity: classEntity,
        teacherEntity: teacherEntity,
        file: fileEntity,
        isActive: json['isActive'] ?? true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('Error parsing document JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'classId': (classEntity as ClassModel).toJson(),
      'teacherId': (teacherEntity as TeacherModel).toJson(),
      'file': (file as FileModel).toJson(),
      'isActive': isActive,
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
    required super.fileName,
    required super.filePath,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
    };
  }
}

