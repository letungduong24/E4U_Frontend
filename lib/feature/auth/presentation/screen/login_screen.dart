import 'package:e4uflutter/shared/presentation/scaffold/guest_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:e4uflutter/feature/auth/presentation/widget/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GuestScaffold(
      title: "Đăng nhập",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}