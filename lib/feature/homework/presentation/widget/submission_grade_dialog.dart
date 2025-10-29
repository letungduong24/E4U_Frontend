import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/domain/entity/submission_entity.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/error_dialog.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionGradeDialog extends StatefulWidget {
  final SubmissionEntity submission;

  const SubmissionGradeDialog({
    super.key,
    required this.submission,
  });

  @override
  State<SubmissionGradeDialog> createState() => _SubmissionGradeDialogState();
}

class _SubmissionGradeDialogState extends State<SubmissionGradeDialog> {
  final gradeController = TextEditingController();
  final feedbackController = TextEditingController();
  
  // Cache để tránh rebuild không cần thiết
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initialize with existing grade if available
    if (widget.submission.grade != null) {
      gradeController.text = widget.submission.grade.toString();
    }
    if (widget.submission.feedback != null) {
      feedbackController.text = widget.submission.feedback!;
    }
  }

  @override
  void dispose() {
    gradeController.dispose();
    feedbackController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 600,
              minHeight: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Chấm bài",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Student Information Section
                    _buildStudentInfoSection(),
                    const SizedBox(height: 20),

                    // Attachment Section
                    _buildAttachmentSection(),
                    const SizedBox(height: 20),

                    // Grade Section
                    _buildGradeSection(),
                    const SizedBox(height: 20),

                    // Feedback Section
                    _buildFeedbackSection(),
                    const SizedBox(height: 24),

                    // Buttons
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ),
          // Loading overlay
          Obx(() {
            final controller = Get.find<HomeworkController>();
            if (controller.isLoadingSubmissions.value) {
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildStudentInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin học sinh",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Học sinh: ${widget.submission.student.name}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              "Đã nộp vào ${DateFormat('dd/MM/yyyy').format(widget.submission.createdAt)}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.submission.file != null && widget.submission.file!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final url = widget.submission.file;
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
                        widget.submission.file ?? 'Không có tên file',
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

  Widget _buildGradeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Điểm",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Nhập điểm (0-10)",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nhận xét",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Nhập nhận xét...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final controller = Get.find<HomeworkController>();
            return ElevatedButton(
              onPressed: controller.isLoadingSubmissions.value ? null : _handleGradeSubmission,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3396D3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Chấm bài",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Hủy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleGradeSubmission() async {
    if (gradeController.text.isEmpty) {
      _showErrorDialog(context, 'Vui lòng nhập điểm');
      return;
    }

    final grade = int.tryParse(gradeController.text);
    if (grade == null || grade < 0 || grade > 10) {
      _showErrorDialog(context, 'Điểm phải là số từ 0 đến 10');
      return;
    }

    if (feedbackController.text.isEmpty) {
      _showErrorDialog(context, 'Vui lòng nhập nhận xét');
      return;
    }

    try {
      final controller = Get.find<HomeworkController>();
      await controller.gradeSubmission(
        submissionId: widget.submission.id,
        grade: grade,
        feedback: feedbackController.text,
      );
      
      // Only close dialog if successful
      Navigator.pop(context);
      // Show success dialog
      _showSuccessDialog(context);
    } catch (e) {
      // Show error alert but keep dialog open
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: "Chấm bài thành công",
      ),
    );
  }
}
