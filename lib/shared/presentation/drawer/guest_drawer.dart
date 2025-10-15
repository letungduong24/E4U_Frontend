import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:get/get.dart';
import 'drawer_item.dart';


class GuestDrawer extends StatelessWidget{
  const GuestDrawer({super.key});

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

            DrawerItem(
              icon: MaterialSymbols.home_outline_rounded,
              title: "Đăng nhập",
              iconColor: Colors.white,
              backgroundColor: const Color(0xFF002055),
              textColor: Colors.white,
              onTap: () => Get.toNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }}