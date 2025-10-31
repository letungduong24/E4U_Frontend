class DocumentManagementEntity {
  final String id;
  final String title;
  final String description;
  final ClassEntity classEntity;
  final TeacherEntity teacherEntity;
  final FileEntity file;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentManagementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.classEntity,
    required this.teacherEntity,
    required this.file,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
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

class TeacherEntity {
  final String id;
  final String name;

  const TeacherEntity({
    required this.id,
    required this.name,
  });
}

class FileEntity {
  final String fileName;
  final String filePath;

  const FileEntity({
    required this.fileName,
    required this.filePath,
  });
}

class DocumentFilterEntity {
  final String? searchQuery;
  final String? classFilter;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const DocumentFilterEntity({
    this.searchQuery,
    this.classFilter,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });
}

