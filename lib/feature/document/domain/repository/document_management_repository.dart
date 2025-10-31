import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';

abstract class DocumentManagementRepository {
  Future<List<DocumentManagementEntity>> getAllDocuments({
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  });

  Future<DocumentManagementEntity> getDocumentById(String documentId);

  Future<DocumentManagementEntity> createDocument({
    required String title,
    required String description,
    required String link,
  });

  Future<DocumentManagementEntity> updateDocument(
    String documentId, {
    String? title,
    String? description,
    String? file,
  });

  Future<void> deleteDocument(String documentId);

  Future<void> toggleDocumentStatus(String documentId, bool isActive);

  Future<List<Map<String, dynamic>>> getClasses();
}

