import 'package:get/get.dart';
import 'package:e4uflutter/feature/document/data/datasource/document_management_datasource.dart';
import 'package:e4uflutter/feature/document/data/repository/document_management_repository_impl.dart';
import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';

class DocumentManagementController extends GetxController {
  // Observable state
  final RxList<DocumentManagementEntity> documents = <DocumentManagementEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedClass = ''.obs;
  final RxBool showActiveOnly = true.obs;
  final RxString sortBy = 'createdAt'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;

  // Dependencies
  late final DocumentManagementRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadDocuments();
    loadClasses();
  }

  void _initializeDependencies() {
    final datasource = DocumentManagementDatasource();
    _repository = DocumentManagementRepositoryImpl(datasource);
  }

  Future<void> loadDocuments() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      print('Loading documents with filters:');
      print('- searchQuery: ${searchQuery.value}');
      print('- classFilter: ${selectedClass.value}');
      print('- sortBy: ${sortBy.value}');
      print('- sortOrder: ${sortOrder.value}');
      
      final result = await _repository.getAllDocuments(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        classFilter: selectedClass.value.isEmpty ? null : selectedClass.value,
        isActive: null,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );
      
      print('Received ${result.length} documents from API');
      documents.value = result;
    } catch (e) {
      print('Error loading documents: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDocument({
    required String title,
    required String description,
    required String file,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.createDocument(
        title: title,
        description: description,
        file: file,
      );
      
      // Clear search query after creating document
      searchQuery.value = '';
      await loadDocuments();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDocument(
    String documentId, {
    String? title,
    String? description,
    String? file,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.updateDocument(
        documentId,
        title: title,
        description: description,
        file: file,
      );
      
      // Clear search query after updating document
      searchQuery.value = '';
      await loadDocuments();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.deleteDocument(documentId);
      
      // Clear search query after deleting document
      searchQuery.value = '';
      await loadDocuments();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void performSearch() {
    loadDocuments();
  }

  void setSelectedClass(String classId) {
    selectedClass.value = classId;
    print('Selected class ID: $classId');
    loadDocuments();
  }

  void setSorting(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    loadDocuments();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedClass.value = '';
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
    loadDocuments();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedClass.value = '';
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
  }

  Future<void> loadClasses() async {
    try {
      print('Loading classes...');
      final classesList = await _repository.getClasses();
      print('Loaded ${classesList.length} classes');
      classes.value = classesList;
    } catch (e) {
      print('Error loading classes: $e');
    }
  }
}

