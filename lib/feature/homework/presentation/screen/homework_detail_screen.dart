import 'package:flutter/material.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';

class HomeworkDetailScreen extends StatelessWidget {
  const HomeworkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: "Chi tiết bài tập",
      body: Center(
        child: Text('Homework Detail - Coming Soon'),
      ),
    );
  }
}

