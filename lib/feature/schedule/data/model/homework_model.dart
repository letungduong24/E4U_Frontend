class HomeworkModel {
  final String id;
  final String classId;
  final String? className;
  final String description;
  final DateTime deadline;
  final String? fileName;
  final String? filePath;
  final String teacherId;
  final String? teacherName;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeworkModel({
    required this.id,
    required this.classId,
    this.className,
    required this.description,
    required this.deadline,
    this.fileName,
    this.filePath,
    required this.teacherId,
    this.teacherName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['_id'] ?? json['id'] ?? '',
      classId: json['classId']?['_id'] ?? json['classId'] ?? '',
      className: json['classId']?['name'] ?? json['classId']?['code'],
      description: json['description'] ?? '',
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      fileName: json['file']?['fileName'],
      filePath: json['file']?['filePath'],
      teacherId: json['teacherId']?['_id'] ?? json['teacherId'] ?? '',
      teacherName: json['teacherId']?['fullName'] ?? json['teacherId']?['name'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'file': {
        'fileName': fileName,
        'filePath': filePath,
      },
      'teacherId': teacherId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get title from description (first 50 characters)
  String get title {
    if (description.length <= 50) return description;
    return '${description.substring(0, 50)}...';
  }

  // Helper method to format deadline for display
  String get formattedDeadline {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    
    if (difference < 0) {
      return 'Quá hạn ${(-difference)} ngày';
    } else if (difference == 0) {
      return 'Hôm nay, ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Ngày mai, ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
    } else {
      return '${deadline.day}/${deadline.month}/${deadline.year}, ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
    }
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
