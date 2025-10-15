import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/mdi.dart';


class StudentDrawer extends HookWidget{
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              title: Text('E4U Education', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),

          SizedBox(height: 15,),

          GestureDetector(
            onTap: () {
              print('Chuyển hươn Profile');
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage:
                    AssetImage('assets/images/default_avatar.jpg'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Lê Tùng Dương',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Color(0xFF002055),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: const Iconify(MaterialSymbols.home_outline_rounded, color: Colors.white,),
              title: const Text(
                'Trang chủ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              onTap: () {},
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: Iconify(Uil.schedule),
              title: const Text(
                'Lịch học',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: Iconify(Mdi.file_document_outline),
              title: const Text(
                'Tài liệu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: Iconify(Mdi.numeric_9_plus_box_outline),
              title: const Text(
                'Xem điểm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: Iconify(Ic.outline_settings),
              title: const Text(
                'Cài đặt',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
          ),

          SizedBox(height: 15,),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              leading: Iconify(MaterialSymbols.logout, color: Colors.red,),
              title: const Text(
                'Đăng xuất',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }}