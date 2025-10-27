import 'package:e4uflutter/feature/document/domain/entity/document_management_entity.dart';
import 'package:e4uflutter/feature/document/presentation/controller/document_management_controller.dart';
import 'package:e4uflutter/feature/document/presentation/widget/update_document_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DocumentProfileDialog extends StatelessWidget {
  final DocumentManagementEntity document;

  const DocumentProfileDialog({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    const Text(
                      "Chi tiết tài liệu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Detail info section
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Mô tả:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Text(
                                  document.description,
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Lớp học:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                document.classEntity.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Giáo viên:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                document.teacherEntity.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tên file:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                document.file.fileName,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ngày tạo:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(document.createdAt),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Chỉ hiển thị nút Xóa và Sửa nếu user là teacher hoặc admin
                          Obx(() {
                            final userRole = AuthController.user.value?.role;
                            final isTeacherOrAdmin = userRole == 'teacher' || userRole == 'admin';
                            
                            if (!isTeacherOrAdmin) {
                              return const SizedBox.shrink();
                            }
                            
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          Navigator.pop(context); // Đóng dialog hiện tại
                                          _showDeleteConfirmation(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: const Text(
                                            "Xóa tài liệu",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.orange,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          Navigator.pop(context); // Đóng dialog hiện tại
                                          _showUpdateDocumentDialog(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: const Text(
                                            "Sửa tài liệu",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final controller = Get.find<DocumentManagementController>();
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: "tài liệu",
        deleteFunction: () => controller.deleteDocument(document.id),
        controller: controller,
      ),
    );
  }

  void _showUpdateDocumentDialog(BuildContext context) {
    final controller = Get.find<DocumentManagementController>();
    showDialog(
      context: context,
      builder: (context) => UpdateDocumentDialog(
        document: document,
        controller: controller,
      ),
    );
  }
}
