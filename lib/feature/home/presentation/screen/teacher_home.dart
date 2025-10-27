import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class TeacherHome extends StatelessWidget{
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
        body: Center(
          child: Column(
            children: [
              Text("Hello teacher")
            ],
          ),
        )
    );
  }}