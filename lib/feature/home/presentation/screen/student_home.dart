import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StudentHome extends HookWidget{
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
        body: Center(
          child: Column(
            children: [
              Text("Hello")
            ],
          ),
        )
    );
  }}