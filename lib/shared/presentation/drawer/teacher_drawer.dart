import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'drawer_item.dart';


class TeacherDrawer extends HookWidget{
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
      ),
      child: SafeArea(
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

          DrawerItem(
            icon: MaterialSymbols.home_outline_rounded,
            title: 'Trang chủ',
            iconColor: Colors.white,
            backgroundColor: const Color(0xFF002055),
            textColor: Colors.white,
            onTap: () {},
          ),

          SizedBox(height: 15,),

          DrawerItem(
            icon: Mdi.file_document_outline,
            title: 'Quản lý tài liệu',
            onTap: () {},
          ),

          SizedBox(height: 15,),

          DrawerItem(
            icon: Mdi.numeric_9_plus_box_outline,
            title: 'Quản lý điểm',
            onTap: () {},
          ),

          SizedBox(height: 15,),

          DrawerItem(
            icon: Uil.schedule,
            title: 'Lịch dạy',
            onTap: () {},
          ),

          SizedBox(height: 15,),

          DrawerItem(
            icon: Ic.outline_settings,
            title: 'Cài đặt',
            onTap: () {},
          ),

          SizedBox(height: 15,),

          DrawerItem(
            icon: MaterialSymbols.logout,
            title: 'Đăng xuất',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {},
          ),
        ],
        ),
      ),
    );
  }}