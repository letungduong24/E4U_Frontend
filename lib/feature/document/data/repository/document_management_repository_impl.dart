import 'package:e4uflutter/feature/document/data/datasource/document_management_datasource.dart';
import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';
import 'package:e4uflutter/feature/document/domain/repository/document_management_repository.dart';

class DocumentManagementRepositoryImpl implements DocumentManagementRepository {
  final DocumentManagementDatasource _datasource;

  DocumentManagementRepositoryImpl(this._datasource);

  @override
  Future<List<DocumentManagementEntity>> getAllDocuments({
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await _datasource.getAllDocuments(
      searchQuery: searchQuery,
      classFilter: classFilter,
      isActive: isActive,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<DocumentManagementEntity> getDocumentById(String documentId) async {
    return await _datasource.getDocumentById(documentId);
  }

  @override
  Future<DocumentManagementEntity> createDocument({
    required String title,
    required String description,
    required String file,
  }) async {
    return await _datasource.createDocument(
      title: title,
      description: description,
      file: file,
    );
  }

  @override
  Future<DocumentManagementEntity> updateDocument(
    String documentId, {
    String? title,
    String? description,
    String? file,
  }) async {
    return await _datasource.updateDocument(
      documentId,
      title: title,
      description: description,
      file: file,
    );
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await _datasource.deleteDocument(documentId);
  }

  @override
  Future<void> toggleDocumentStatus(String documentId, bool isActive) async {
    await _datasource.toggleDocumentStatus(documentId, isActive);
  }

  @override
  Future<List<Map<String, dynamic>>> getClasses() async {
    return await _datasource.getClasses();
  }
}

