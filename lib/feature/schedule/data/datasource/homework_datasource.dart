import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e4uflutter/core/config/api_config.dart';
import 'package:e4uflutter/feature/schedule/data/model/homework_model.dart';

class HomeworkDataSource {
  final http.Client _client;

  HomeworkDataSource({http.Client? client}) : _client = client ?? http.Client();

  // Get upcoming assignments
  Future<List<HomeworkModel>> getUpcomingAssignments(String? token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.upcomingAssignments}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final List<dynamic> assignmentsJson = data['data'];
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
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.overdueAssignments}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final List<dynamic> assignmentsJson = data['data'];
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
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.homeworks}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final List<dynamic> assignmentsJson = data['data'];
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
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.homeworkById(homeworkId)}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.homeworks}'),
        headers: ApiConfig.getHeaders(token),
        body: json.encode(homeworkData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
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
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.homeworkById(homeworkId)}'),
        headers: ApiConfig.getHeaders(token),
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.homeworkById(homeworkId)}'),
        headers: ApiConfig.getHeaders(token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete homework: $e');
    }
  }
}
