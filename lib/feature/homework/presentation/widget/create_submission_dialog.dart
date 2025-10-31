import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/error_dialog.dart';

class CreateSubmissionDialog extends StatefulWidget {
  final String homeworkId;

  const CreateSubmissionDialog({
    super.key,
    required this.homeworkId,
  });

  @override
  State<CreateSubmissionDialog> createState() => _CreateSubmissionDialogState();
}

class _CreateSubmissionDialogState extends State<CreateSubmissionDialog> {
  final filePathController = TextEditingController();
  
  @override
  void dispose() {
    filePathController.dispose();
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tải lên file",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // File path field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Đường dẫn file",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: filePathController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: "Nhập đường dẫn file",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final controller = Get.find<HomeworkController>();
                    return ElevatedButton(
                      onPressed: controller.isLoadingStudentSubmission.value ? null : () => _handleSubmit(context),
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
                        "Xác nhận",
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (filePathController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          message: 'Vui lòng nhập đường dẫn file',
        ),
      );
      return;
    }

    try {
      final controller = Get.find<HomeworkController>();
      await controller.submitHomework(
        homeworkId: widget.homeworkId,
        file: filePathController.text,
      );
      
      // Only close dialog if successful
      Navigator.pop(context);
      // Show success dialog
      _showSuccessDialog(context);
    } catch (e) {
      // Show error alert but keep dialog open
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Lỗi"),
          content: Text(e.toString()),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: "Nộp bài thành công",
      ),
    );
  }
}

