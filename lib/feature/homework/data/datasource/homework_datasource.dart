import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/homework/data/model/homework_model.dart';

class HomeworkDataSource {
  final DioClient _dioClient = DioClient();

  // Get upcoming assignments
  Future<List<HomeworkModel>> getUpcomingAssignments(String? token) async {
    try {
      final response = await _dioClient.dio.get('/homeworks/upcoming');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          // Handle both array and object responses
          List<dynamic> assignmentsJson;
          if (data['data'] is List) {
            assignmentsJson = data['data'];
          } else if (data['data'] is Map && data['data']['homeworks'] != null) {
            assignmentsJson = data['data']['homeworks'];
          } else {
            assignmentsJson = [];
          }
          return assignmentsJson.map((json) => HomeworkModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch upcoming assignments: $e');
    }
  }

  // Get overdue assignments
  Future<List<HomeworkModel>> getOverdueAssignments(String? token) async {
    try {
      final response = await _dioClient.dio.get('/homeworks/overdue');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          // Handle both array and object responses
          List<dynamic> assignmentsJson;
          if (data['data'] is List) {
            assignmentsJson = data['data'];
          } else if (data['data'] is Map && data['data']['homeworks'] != null) {
            assignmentsJson = data['data']['homeworks'];
          } else {
            assignmentsJson = [];
          }
          return assignmentsJson.map((json) => HomeworkModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch overdue assignments: $e');
    }
  }

  // Get all homework assignments
  Future<List<HomeworkModel>> getAllHomework(String? token) async {
    try {
      final response = await _dioClient.dio.get('/homeworks');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          // Handle both array and object responses
          List<dynamic> assignmentsJson;
          if (data['data'] is List) {
            assignmentsJson = data['data'];
          } else if (data['data'] is Map && data['data']['homeworks'] != null) {
            assignmentsJson = data['data']['homeworks'];
          } else {
            assignmentsJson = [];
          }
          return assignmentsJson.map((json) => HomeworkModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch homework assignments: $e');
    }
  }

  // Get homework by ID
  Future<HomeworkModel> getHomeworkById(String homeworkId, String? token) async {
    try {
      final response = await _dioClient.dio.get('/homeworks/$homeworkId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['homework'] != null) {
          return HomeworkModel.fromJson(data['data']['homework']);
        }
      }
      throw Exception('Homework not found');
    } catch (e) {
      throw Exception('Failed to fetch homework: $e');
    }
  }

  // Create homework (Teacher only)
  Future<HomeworkModel> createHomework(Map<String, dynamic> homeworkData, String? token) async {
    try {
      final response = await _dioClient.dio.post(
        '/homeworks',
        data: homeworkData,
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['homework'] != null) {
          return HomeworkModel.fromJson(data['data']['homework']);
        }
      }
      throw Exception('Failed to create homework');
    } catch (e) {
      throw Exception('Failed to create homework: $e');
    }
  }

  // Update homework (Teacher only)
  Future<HomeworkModel> updateHomework(String homeworkId, Map<String, dynamic> updates, String? token) async {
    try {
      final response = await _dioClient.dio.put(
        '/homeworks/$homeworkId',
        data: updates,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['homework'] != null) {
          return HomeworkModel.fromJson(data['data']['homework']);
        }
      }
      throw Exception('Failed to update homework');
    } catch (e) {
      throw Exception('Failed to update homework: $e');
    }
  }

  // Delete homework (Teacher only)
  Future<bool> deleteHomework(String homeworkId, String? token) async {
    try {
      final response = await _dioClient.dio.delete('/homeworks/$homeworkId');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete homework: $e');
    }
  }

  // Get homework by class ID
  Future<List<HomeworkModel>> getClassHomework(String classId, String? token) async {
    try {
      final response = await _dioClient.dio.get('/homeworks?class_id=$classId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          // Handle both array and object responses
          List<dynamic> assignmentsJson;
          if (data['data'] is List) {
            assignmentsJson = data['data'];
          } else if (data['data'] is Map && data['data']['homeworks'] != null) {
            assignmentsJson = data['data']['homeworks'];
          } else {
            assignmentsJson = [];
          }
          return assignmentsJson.map((json) => HomeworkModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch class homework: $e');
    }
  }
}