import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';

class UpdateSubmissionDialog extends StatefulWidget {
  final Function(String filePath) onConfirm;
  final String? currentFile;
  final String submissionId;

  const UpdateSubmissionDialog({
    super.key,
    required this.onConfirm,
    this.currentFile,
    required this.submissionId,
  });

  @override
  State<UpdateSubmissionDialog> createState() => _UpdateSubmissionDialogState();
}

class _UpdateSubmissionDialogState extends State<UpdateSubmissionDialog> {
  late final TextEditingController filePathController;
  
  @override
  void initState() {
    super.initState();
    filePathController = TextEditingController(text: widget.currentFile ?? '');
  }
  
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
              "Cập nhật bài nộp",
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
                  child: ElevatedButton(
                    onPressed: () async {
                      if (filePathController.text.isNotEmpty) {
                        await _handleUpdate(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập đường dẫn file'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF7722),
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
                  ),
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

  Future<void> _handleUpdate(BuildContext context) async {
    try {
      final controller = Get.find<HomeworkController>();
      await controller.updateSubmission(
        submissionId: widget.submissionId,
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
        title: "Cập nhật thành công",
      ),
    );
  }
}

