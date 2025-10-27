import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class StudentHome extends StatelessWidget{
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
        body: Center(
          child: Column(
            children: [
              Text("Hello student")
            ],
          ),
        )
    );
  }}