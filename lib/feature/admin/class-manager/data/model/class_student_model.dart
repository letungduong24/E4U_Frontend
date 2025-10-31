import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';

class ClassStudentModel extends ClassStudentEntity {
  const ClassStudentModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.classId,
    required super.className,
    required super.classCode,
  });

  factory ClassStudentModel.fromJson(Map<String, dynamic> json) {
    final currentClass = json['currentClass'] as Map<String, dynamic>?;
    
    return ClassStudentModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fullName: '${json['firstName']} ${json['lastName']}',
      email: json['email'] as String,
      classId: currentClass?['_id'] as String? ?? '',
      className: currentClass?['name'] as String? ?? '',
      classCode: currentClass?['code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'currentClass': {
        '_id': classId,
        'name': className,
        'code': classCode,
      },
    };
  }
}

class ClassStudentsResponseModel extends ClassStudentsResponseEntity {
  const ClassStudentsResponseModel({
    required super.classId,
    required super.className,
    required super.classCode,
    required super.description,
    required super.maxStudents,
    required super.isActive,
    super.homeroomTeacherName,
    required super.students,
  });

  factory ClassStudentsResponseModel.fromJson(Map<String, dynamic> json) {
    final classData = json['class'] as Map<String, dynamic>;
    final studentsJson = json['students'] as List<dynamic>? ?? [];
    
    final students = studentsJson.map((studentJson) => 
      ClassStudentModel.fromJson(studentJson as Map<String, dynamic>)
    ).toList();

    // Parse homeroom teacher name from class data
    String? homeroomTeacherName;
    if (classData['homeroomTeacher'] != null) {
      final teacherData = classData['homeroomTeacher'];
      if (teacherData is Map<String, dynamic>) {
        homeroomTeacherName = _buildTeacherName(teacherData);
      }
    }

    return ClassStudentsResponseModel(
      classId: classData['_id'] as String,
      className: classData['name'] as String,
      classCode: classData['code'] as String,
      description: classData['description'] as String? ?? '',
      maxStudents: classData['maxStudents'] as int,
      isActive: classData['isActive'] as bool,
      homeroomTeacherName: homeroomTeacherName,
      students: students,
    );
  }

  static String? _buildTeacherName(Map<String, dynamic> teacherData) {
    // Try different possible formats for teacher name
    if (teacherData['fullName'] != null) {
      return teacherData['fullName'];
    }
    if (teacherData['name'] != null) {
      return teacherData['name'];
    }
    
    // Build from firstName and lastName
    final firstName = teacherData['firstName']?.toString() ?? '';
    final lastName = teacherData['lastName']?.toString() ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'class': {
        '_id': classId,
        'name': className,
        'code': classCode,
        'description': description,
        'maxStudents': maxStudents,
        'isActive': isActive,
      },
      'students': students.map((student) => (student as ClassStudentModel).toJson()).toList(),
    };
  }
}
