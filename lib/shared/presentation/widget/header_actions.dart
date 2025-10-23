import 'package:flutter/material.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Notification button
        InkWell(
          onTap: () {
            // TODO: Navigate to notifications page
            print('Notification tapped');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Menu button
        InkWell(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.grid_view,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
