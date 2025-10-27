class HomeworkEntity {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FileEntity? file;
  final ClassEntity classEntity;
  final TeacherEntity teacherEntity;

  const HomeworkEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.file,
    required this.classEntity,
    required this.teacherEntity,
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
  final String? fileName;
  final String? filePath;

  const FileEntity({
    this.fileName,
    this.filePath,
  });
}

class HomeworkFilterEntity {
  final String? searchQuery;
  final String? classFilter;
  final String? sortBy;
  final String? sortOrder;

  const HomeworkFilterEntity({
    this.searchQuery,
    this.classFilter,
    this.sortBy,
    this.sortOrder,
  });
}

