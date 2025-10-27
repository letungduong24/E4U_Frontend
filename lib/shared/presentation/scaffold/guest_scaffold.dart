import 'package:e4uflutter/shared/presentation/drawer/guest_drawer.dart';
import 'package:flutter/material.dart';


class GuestScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  const GuestScaffold({
    super.key,
    required this.body,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: GuestDrawer(),
      body: Builder(
        builder: (context) => Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: Icon(
                          Icons.apps,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
