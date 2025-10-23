import 'package:flutter/material.dart';
import 'package:e4uflutter/shared/presentation/widget/success_popup.dart';
import 'package:e4uflutter/shared/presentation/widget/error_popup.dart';
import 'package:e4uflutter/shared/presentation/widget/schedule_success_popup.dart';
import 'package:e4uflutter/shared/presentation/widget/homework_success_popup.dart';

class PopupHelper {
  // Schedule Success Popups
  static void showCreateScheduleSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScheduleSuccessPopup(
        title: 'Tạo lịch thành công',
        message: 'Lịch học đã được tạo thành công.',
        primaryButtonText: 'Xem lịch',
        secondaryButtonText: 'Đóng',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          // Navigate to schedule view
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static void showUpdateScheduleSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScheduleSuccessPopup(
        title: 'Sửa lịch thành công',
        message: 'Lịch học đã được cập nhật thành công.',
        primaryButtonText: 'Xem lịch',
        secondaryButtonText: 'Đóng',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          // Navigate to schedule view
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // Homework Success Popups
  static void showCreateHomeworkSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => HomeworkSuccessPopup(
        title: 'Tạo bài tập thành công',
        message: 'Bài tập đã được tạo thành công.',
        primaryButtonText: 'Xem bài',
        secondaryButtonText: 'Đóng',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          // Navigate to homework view
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static void showUpdateHomeworkSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => HomeworkSuccessPopup(
        title: 'Sửa bài tập thành công',
        message: 'Bài tập đã được cập nhật thành công.',
        primaryButtonText: 'Xem bài',
        secondaryButtonText: 'Đóng',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          // Navigate to homework view
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // Error Popup
  static void showError(BuildContext context, {String? customMessage}) {
    showDialog(
      context: context,
      builder: (context) => ErrorPopup(
        title: 'Lỗi',
        message: customMessage ?? 'Đã có lỗi xảy ra. Vui lòng thử lại sau!',
        buttonText: 'Đóng',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // Generic Success Popup
  static void showSuccess(BuildContext context, {
    required String title,
    required String message,
    required String primaryButtonText,
    required String secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => SuccessPopup(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
      ),
    );
  }
}
