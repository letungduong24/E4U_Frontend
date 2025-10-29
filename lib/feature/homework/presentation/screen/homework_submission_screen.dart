import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/upload_file_dialog.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/update_submission_dialog.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkSubmissionScreen extends StatefulWidget {
  const HomeworkSubmissionScreen({super.key});

  @override
  State<HomeworkSubmissionScreen> createState() => _HomeworkSubmissionScreenState();
}

class _HomeworkSubmissionScreenState extends State<HomeworkSubmissionScreen> {
  late HomeworkEntity homework;
  String? _selectedFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      homework = arguments['homework'] as HomeworkEntity;
      // Load student submission
      final controller = Get.find<HomeworkController>();
      controller.loadStudentSubmissionByHomework(homework.id);
    } else {
      throw Exception('No homework provided');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: "Nộp bài tập",
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<HomeworkController>();
          // Reload homework list to get updated homework info
          await controller.loadHomeworks();
          // Find updated homework from the list
          final updatedHomework = controller.homeworks.firstWhere(
            (h) => h.id == homework.id,
            orElse: () => homework,
          );
          setState(() {
            homework = updatedHomework;
          });
          // Reload student submission
          await controller.loadStudentSubmissionByHomework(homework.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Homework Title Section
                    _buildTitleSection(),
                    
                    const SizedBox(height: 16),
                    
                    // Instructions Section
                    _buildInstructionsSection(),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Attachment Section (Teacher's file) - Full width with margin
              if (homework.file != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildAttachmentSection(),
                ),
              
              if (homework.file != null) const SizedBox(height: 16),
              
              // Submission Information Section - Full width with margin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSubmissionSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    final currentTitle = homework.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ngày tới hạn: ${DateFormat('dd/MM/yyyy').format(homework.deadline)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            homework.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSection() {
    if (homework.file == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đính kèm",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              "Đã đăng vào ${DateFormat('HH:mm dd/MM/yyyy').format(homework.createdAt)}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final url = homework.file!.filePath;
                if (url != null && url.isNotEmpty) {
                  String fullUrl = url;
                  try {
                    if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
                      fullUrl = 'https://$fullUrl';
                    }
                    
                    final uri = Uri.parse(fullUrl);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Lỗi"),
                          content: Text("Không thể mở liên kết: $fullUrl"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3396D3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      homework.file!.fileName ?? homework.file!.filePath ?? 'Không có tên file',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin nộp bài",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() {
            final controller = Get.find<HomeworkController>();
            final submission = controller.studentSubmission.value;
            
            return Center(
              child: Text(
                submission != null 
                  ? "Đã nộp vào ${DateFormat('HH:mm dd/MM/yyyy').format(submission.createdAt)}" 
                  : "Chưa nộp bài",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Obx(() {
            final controller = Get.find<HomeworkController>();
            final submission = controller.studentSubmission.value;
            
            if (submission == null) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showUploadFileDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3396D3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_upload, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Nộp bài',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = submission.file;
                        if (url != null && url.isNotEmpty) {
                          String fullUrl = url;
                          try {
                            if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
                              fullUrl = 'https://$fullUrl';
                            }
                            
                            final uri = Uri.parse(fullUrl);
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Lỗi"),
                                  content: Text("Không thể mở liên kết: $fullUrl"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3396D3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              submission.file ?? 'Không có tên file',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showUpdateSubmissionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF7722),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sửa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  void _showUploadFileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UploadFileDialog(
        homeworkId: homework.id,
      ),
    );
  }

  void _showUpdateSubmissionDialog(BuildContext context) {
    final controller = Get.find<HomeworkController>();
    final submission = controller.studentSubmission.value;
    
    if (submission == null) return;
    
    showDialog(
      context: context,
      builder: (context) => UpdateSubmissionDialog(
        currentFile: submission.file,
        submissionId: submission.id,
        onConfirm: (filePath) {
          // This callback is no longer needed since _handleUpdate is called directly
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final controller = Get.find<HomeworkController>();
    final submission = controller.studentSubmission.value;

    if (submission == null) return;

    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: "bài nộp",
        controller: controller,
        deleteFunction: () async {
          await controller.deleteSubmission(submission.id);
        },
      ),
    );
  }
}
