import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/document/data/model/document_management_model.dart';

class DocumentManagementDatasource {
  final Dio _dio = DioClient().dio;

  Future<List<DocumentManagementModel>> getAllDocuments({
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      // Determine endpoint based on whether search is being used
      String endpoint = '/documents';
      final queryParams = <String, dynamic>{};
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        endpoint = '/documents/search';
        queryParams['q'] = searchQuery;
      }
      
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      
      // Handle API response structure
      List<dynamic> documentsJson;
      if (response.data['data'] is List) {
        documentsJson = response.data['data'];
      } else if (response.data['data'] is Map && response.data['data']['documents'] is List) {
        documentsJson = response.data['data']['documents'];
      } else {
        documentsJson = [];
      }
      
      final allDocuments = <DocumentManagementModel>[];
      for (int i = 0; i < documentsJson.length; i++) {
        try {
          final document = DocumentManagementModel.fromJson(documentsJson[i]);
          allDocuments.add(document);
        } catch (e) {
          // Skip invalid documents
        }
      }
      
      // Note: Backend handles search filtering, so we don't need to filter here
      
      // Filter by active status
      var filteredDocuments = allDocuments;
      if (isActive != null) {
        filteredDocuments = filteredDocuments.where((doc) => doc.isActive == isActive).toList();
      }
      
      // Sort documents
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'createdAt') {
          if (sortOrder == 'desc') {
            filteredDocuments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          } else {
            filteredDocuments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
        } else if (sortBy == 'title') {
          if (sortOrder == 'desc') {
            filteredDocuments.sort((a, b) => b.title.compareTo(a.title));
          } else {
            filteredDocuments.sort((a, b) => a.title.compareTo(b.title));
          }
        }
      }
      
      return filteredDocuments;
    } on DioException catch (e) {
      throw Exception('Lấy danh sách tài liệu thất bại');
    } catch (e) {
      throw Exception('Lấy danh sách tài liệu thất bại');
    }
  }

  Future<DocumentManagementModel> getDocumentById(String documentId) async {
    try {
      final response = await _dio.get('/documents/$documentId');
      return DocumentManagementModel.fromJson(response.data['data']['document']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy thông tin tài liệu thất bại');
    }
  }

  Future<DocumentManagementModel> createDocument({
    required String title,
    required String description,
    required String file,
  }) async {
    try {
      final requestData = {
        'title': title,
        'description': description,
        'file': file,
      };

      final response = await _dio.post('/documents', data: requestData);
      
      return DocumentManagementModel.fromJson(response.data['data']['document']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Tạo tài liệu thất bại');
    }
  }

  Future<DocumentManagementModel> updateDocument(
    String documentId, {
    String? title,
    String? description,
    String? file,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (file != null) data['file'] = file;

      final response = await _dio.put(
        '/documents/$documentId',
        data: data,
      );
      
      return DocumentManagementModel.fromJson(response.data['data']['document']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Cập nhật tài liệu thất bại');
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await _dio.delete('/documents/$documentId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa tài liệu thất bại');
    }
  }

  Future<void> toggleDocumentStatus(String documentId, bool isActive) async {
    try {
      await _dio.patch('/documents/$documentId/active', data: {'isActive': isActive});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Thay đổi trạng thái tài liệu thất bại');
    }
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      final response = await _dio.get('/classes');
      
      List<dynamic> classesJson;
      if (response.data['data'] != null && response.data['data']['classes'] != null) {
        classesJson = response.data['data']['classes'];
      } else if (response.data['data'] is List) {
        classesJson = response.data['data'];
      } else {
        classesJson = [];
      }
      
      final classes = classesJson.map((json) => {
        'id': json['_id'],
        'name': json['name'],
        'code': json['code'],
      }).toList();
      
      return classes;
    } on DioException catch (e) {
      return _getMockClasses();
    } catch (e) {
      return _getMockClasses();
    }
  }

  List<Map<String, dynamic>> _getMockClasses() {
    return [
      {
        'id': '68f11b630db875085481a9a5',
        'name': 'IELTS Foundation - Band 4.0-5.5',
        'code': 'IELTS-FOUNDATION',
      },
      {
        'id': '68f11b630db875085481a9a6',
        'name': 'IELTS Advanced - Band 6.0-7.5',
        'code': 'IELTS-ADVANCED',
      },
    ];
  }
}

