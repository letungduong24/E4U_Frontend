class HomeworkEntity {
  final String id;
  final String classId;
  final String? className;
  final String title;
  final String description;
  final DateTime deadline;
  final String? fileName;
  final String? filePath;
  final String? attachmentUrl;
  final String? attachmentName;
  final String teacherId;
  final String? teacherName;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeworkEntity({
    required this.id,
    required this.classId,
    this.className,
    required this.title,
    required this.description,
    required this.deadline,
    this.fileName,
    this.filePath,
    this.attachmentUrl,
    this.attachmentName,
    required this.teacherId,
    this.teacherName,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper method to format deadline for display
  String get formattedDeadline {
    return '${deadline.day.toString().padLeft(2, '0')}/${deadline.month.toString().padLeft(2, '0')}/${deadline.year}';
  }

  // Helper method to check if assignment is overdue
  bool get isOverdue => deadline.isBefore(DateTime.now());

  // Helper method to check if assignment is due soon (within 3 days)
  bool get isDueSoon {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    return difference >= 0 && difference <= 3;
  }
}
