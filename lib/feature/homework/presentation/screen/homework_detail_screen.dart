import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/submission_grade_dialog.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/update_homework_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkDetailScreen extends StatefulWidget {
  const HomeworkDetailScreen({super.key});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  late final TextEditingController titleController;
  late HomeworkEntity homework;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      homework = arguments['homework'] as HomeworkEntity;
      titleController = TextEditingController(text: homework.title);
      
      // Load submissions for this homework
      final controller = Get.find<HomeworkController>();
      controller.loadSubmissionsByHomework(homework.id);
    } else {
      throw Exception('No homework provided');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeworkController>();
    
    return HeaderScaffold(
      title: "Xem chi tiết bài tập",
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadSubmissionsByHomework(homework.id);
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
                  // Homework Title Input with Edit/Delete buttons
                  _buildTitleSection(context, controller),
                  
                  const SizedBox(height: 16),
                  
                  // Instructions Section
                  _buildInstructionsSection(),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Attachment Section - Full width with margin
            if (homework.file != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildAttachmentSection(),
              ),
            
            const SizedBox(height: 16),
            
            // Student Submissions Table Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildStudentSubmissionsTable(),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, HomeworkController controller) {
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
              const SizedBox(width: 8),
              // Chỉ hiển thị nút Edit và Delete nếu là teacher hoặc admin
              Obx(() {
                final userRole = AuthController.user.value?.role;
                final isTeacherOrAdmin = userRole == 'teacher' || userRole == 'admin';
                
                if (!isTeacherOrAdmin) {
                  return const SizedBox.shrink();
                }
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            final controller = Get.find<HomeworkController>();
                            _showUpdateHomeworkDialog(context, controller);
                          },
                          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => _showDeleteConfirmation(context),
                          icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
                    // Ensure URL has protocol
                    if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
                      fullUrl = 'https://$fullUrl';
                    }
                    
                    final uri = Uri.parse(fullUrl);
                    // Try to launch the URL directly
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    // Show error dialog with actual error
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
                      homework.file!.filePath ?? homework.file!.fileName ?? 'Không có tên file',
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

  void _showDeleteConfirmation(BuildContext context) {
    final controller = Get.find<HomeworkController>();
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: "bài tập",
        deleteFunction: () async {
          await controller.deleteHomework(homework.id);
          Get.back(); // Go back to homework list
        },
        controller: controller,
      ),
    );
  }

  void _showUpdateHomeworkDialog(BuildContext context, HomeworkController controller) async {
    await showDialog(
      context: context,
      builder: (context) => UpdateHomeworkDialog(
        homework: homework,
        controller: controller,
      ),
    );
    
    // After update, reload homework detail from controller's homeworks list
    if (mounted) {
      setState(() {
        // Update homework from controller's homeworks list
        final updatedHomework = controller.homeworks.firstWhereOrNull((h) => h.id == homework.id);
        if (updatedHomework != null) {
          homework = updatedHomework;
          titleController.text = homework.title;
        }
      });
    }
  }

  Widget _buildStudentSubmissionsTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
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
                            width: 200,
                            child: Row(
                              children: [
                                const Text(
                                  "Tên",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                const Text(
                                  "Điểm",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Chấm bài",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Rows
                    Obx(() {
                      final submissions = Get.find<HomeworkController>().submissions;
                      if (submissions.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(40),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  "Không có bài nộp nào",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: submissions.map((submission) => Container(
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
                                width: 200,
                                child: Text(
                                  submission.student.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  submission.status == 'graded' 
                                    ? submission.grade?.toString() ?? 'Chưa chấm'
                                    : 'Chưa chấm',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: submission.status == 'graded' ? Colors.black87 : Colors.grey[600],
                                    fontWeight: submission.status == 'graded' ? FontWeight.w500 : FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: IconButton(
                                  onPressed: () {
                                    _showGradeDialog(context, submission);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGradeDialog(BuildContext context, submission) {
    showDialog(
      context: context,
      builder: (context) => SubmissionGradeDialog(
        submission: submission,
      ),
    );
  }
}
