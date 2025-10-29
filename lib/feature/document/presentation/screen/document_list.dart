import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/document/presentation/controller/document_management_controller.dart';
import 'package:e4uflutter/feature/document/presentation/widget/create_document_dialog.dart';
import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:intl/intl.dart';

class DocumentListScreen extends StatelessWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DocumentManagementController());
    
    return Obx(() {
      final userRole = AuthController.user.value?.role;
      final title = (userRole == 'student') ? "Tài liệu" : "Quản lý tài liệu";
      
      return HeaderScaffold(
        title: title,
        body: RefreshIndicator(
        onRefresh: () async {
          controller.resetFilters();
          await controller.loadDocuments();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         kToolbarHeight - 100,
            ),
            child: IntrinsicHeight(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Có lỗi xảy ra: ${controller.error.value}",
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.loadDocuments,
                          child: const Text("Thử lại"),
                        ),
                      ],
                    ),
                  );
                }
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!, width: 0.5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: controller.setSearchQuery,
                                  onSubmitted: (value) => controller.performSearch(),
                                  style: const TextStyle(fontSize: 14, height: 1.0),
                                  decoration: const InputDecoration(
                                    hintText: "Tìm kiếm",
                                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey, height: 1.0),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Tiêu đề",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(Icons.keyboard_arrow_up, size: 16),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          "Ngày tạo",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Chi tiết",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.documents.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(40),
                                    child: const Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.description_outlined, size: 48, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            "Không có tài liệu nào",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ...controller.documents.map((document) => Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document.title,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                document.description.length > 50 
                                                  ? '${document.description.substring(0, 50)}...'
                                                  : document.description,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(document.createdAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: IconButton(
                                            onPressed: () => _showDocumentDetails(context, document),
                                            icon: Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      floatingButton: Obx(() {
        final userRole = AuthController.user.value?.role;
        final isTeacherOrAdmin = userRole == 'teacher' || userRole == 'admin';
        
        if (!isTeacherOrAdmin) {
          return const SizedBox.shrink();
        }
        
        return FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateDocumentDialog(controller: controller),
          ),
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
      );
    });
  }

  void _showDocumentDetails(BuildContext context, DocumentManagementEntity document) {
    Get.toNamed('/document-detail', arguments: {
      'document': document,
    });
  }
}

