import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class DrawerItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        leading: Iconify(icon, color: iconColor ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor ?? Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
