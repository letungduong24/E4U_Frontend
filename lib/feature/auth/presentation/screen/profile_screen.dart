import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/shared/presentation/button.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/shared/utils/role_util.dart';
import 'package:e4uflutter/shared/utils/status_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: "Trang cá nhân",
      body: Center(
        // 👇 Chỉ cần 1 Obx bao ngoài toàn bộ nội dung
        child: Obx(() {
          final user = AuthController.user.value;
          final avatarUrl = user?.profile?.avatar;
          final birthOfDate = user?.profile?.dateOfBirth != null
              ? DateFormat('dd/MM/yyyy').format(user!.profile!.dateOfBirth!)
              : "Chưa cập nhật";
          final phoneNumber = user?.profile?.phone ?? "Chưa cập nhật";
          final address = user?.profile?.address ?? "Chưa cập nhật";

          return Column(
            children: [
              // Avatar + Basic info
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage('assets/images/default_avatar.jpg')
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null ? user.fullName : "Người dùng",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            user != null
                                ? RoleUtil.GetRoleTitle(user)
                                : "Người dùng",
                            style: const TextStyle(fontSize: 15),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //Detail info section
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ngày sinh:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          birthOfDate,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          phoneNumber,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Địa chỉ:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          address,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: DefaultButton(
                        text: "Yêu cầu sửa thông tin",
                        borderRadius: 20,
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              ),
              // enrollment history
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lịch sử học tập", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    SizedBox(height: 5,),
                    if (user?.enrollmentHistory != null)
                      ...?user?.enrollmentHistory?.map((item) =>
                          Container(
                            padding: EdgeInsets.all((12)),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.className, style: TextStyle(fontWeight: FontWeight.bold),),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: StatusUtil.GetStatusDisplayColor(item.status),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(StatusUtil.GetStatusDisplayName(item.status), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),),
                                    )
                                  ],
                                ),
                                Text("Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(item.enrolledAt)}"),
                                Text("Ngày kết thúc: ${item.completedAt != null ? DateFormat('dd/MM/yyyy').format(item.completedAt!) : 'Chưa kết thúc'}")
                              ],
                            ),
                          )
                      )
                    else
                      Text("Không có lịch sử học"),
                  ],
                ),
              )

            ],
          );
        }),
      ),
    );
  }
}
